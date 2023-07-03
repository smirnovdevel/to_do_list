import '../../data/datasources/local_data_source.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/utils/device_id.dart';
import '../../utils/core/logging.dart';
import '../../utils/core/network_info.dart';
import '../../utils/error/exception.dart';
import '../models/todo.dart';

final Logging log = Logging('TodoService');

class TodoService {
  TodoService({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  String? deviceId;

  Future<void> getId() async {
    deviceId ??= await getDeviceID();
    log.info('Device id: $deviceId');
  }

  /// GET All Todos
  ///
  Future<List<Todo>> getTodos() async {
    List<Todo> localTodosList = [];
    List<Todo> remoteTodosList = [];
    List<Todo> todosList = [];

    /// check internet connection
    log.info('Get Todos from Server...');
    if (await networkInfo.isConnected) {
      /// Получаем список задач с сервера
      ///
      remoteTodosList = await remoteDataSource.getTodos();
      log.info('Get ${remoteTodosList.length} from Server');
    } else {
      log.warning('No Internet connection');
    }
    log.info('Get Todos from DB...');
    localTodosList = await localDataSource.getTodos();
    log.info('Get ${localTodosList.length} todos from DB');

    /// Проверям даты последнего изменения задачи, по последней истинная
    ///
    if (remoteTodosList.isNotEmpty) {
      /// C сервера получены какие-то задачи
      ///
      if (localTodosList.isEmpty) {
        /// База пустая
        ///
        await localDataSource.updateTodos(todos: remoteTodosList);
        for (Todo todo in remoteTodosList) {
          todosList.add(todo.copyWith(upload: true));
        }
      } else {
        /// Есть список с сервера и есть список из базы,
        /// для быстрого поиска составим две мапы
        ///
        Map<String, DateTime> remoteTodosMap = {
          for (var todo in remoteTodosList) todo.uuid: todo.changed!
        };
        Map<String, DateTime> localeTodosMap = {
          for (var todo in localTodosList) todo.uuid: todo.changed!
        };

        /// Перебираем все задания с сервера и сравниваем с теми, что загружены из базы
        ///
        List<Todo> localDelete = [];
        List<String> uuidProcessed = [];
        for (String uuid in remoteTodosMap.keys) {
          /// Сопоставление тудушек полученных с сервера
          /// с тудушками в базе по uuid
          ///
          if (localeTodosMap.containsKey(uuid)) {
            /// такая задача в базе есть
            ///
            Todo localTodo =
                localTodosList.firstWhere((todo) => todo.uuid == uuid);
            if (localeTodosMap[uuid]!.isBefore(remoteTodosMap[uuid]!)) {
              /// на сервере версия свежее, проверяем не удалена ли
              if (localTodo.deleted) {
                localDelete.add(localTodo);
              } else {
                todosList.add(
                    remoteTodosList.firstWhere((todo) => todo.uuid == uuid));
              }
            } else if (remoteTodosMap[uuid]!.isBefore(localeTodosMap[uuid]!)) {
              /// в базе версия свежее, проверяем не удалена ли
              if (localTodo.deleted) {
                localDelete.add(localTodo);
              } else {
                todosList.add(
                    localTodosList.firstWhere((todo) => todo.uuid == uuid));
              }
            } else {
              /// записи совпадают, просто добавляем в список, берём версию с сервера
              /// там уже upload = true
              todosList
                  .addAll(remoteTodosList.where((todo) => todo.uuid == uuid));
            }

            /// сохраняем совпадения
            uuidProcessed.add(uuid);
          } else {
            /// если такой задачи в базе нет, добавляем в общий список
            /// и список для обновления в базе
            todosList
                .addAll(remoteTodosList.where((todo) => todo.uuid == uuid));
          }
        }

        /// Удаляем совпавшие uuid из списка локальных таск, эти таски есть на сервере
        /// остануться только те, которых нет на сервере
        localeTodosMap.removeWhere((key, value) => uuidProcessed.contains(key));
        uuidProcessed.clear();
        remoteTodosMap.clear();

        /// Если в базе есть задачи, которых нет на сервере, возможны варианты
        /// 1. Задачу удалили с другого устройства, upload = true, удаляем из базы
        for (String uuid in localeTodosMap.keys) {
          localDelete.addAll(
              localTodosList.where((todo) => todo.uuid == uuid && todo.upload));
        }

        /// 2. Они не были выгружены на сервер и не удалены, upload = false, delete = false
        /// добавляем в общий список и список обновления на сервере
        for (String uuid in localeTodosMap.keys) {
          todosList.addAll(localTodosList.where(
              (todo) => todo.uuid == uuid && !todo.upload && !todo.deleted));
        }

        /// 3. Они не были выгружены на сервер и удалены, upload = false, delete = true
        /// удаляем из базы
        for (String uuid in localeTodosMap.keys) {
          localDelete.addAll(localTodosList.where(
              (todo) => todo.uuid == uuid && !todo.upload && todo.deleted));
        }

        /// Удаляем лишние таски из базы
        ///
        if (localDelete.isNotEmpty) {
          for (Todo todo in localDelete) {
            await localDataSource.deleteTodo(todo: todo);
          }
          localDelete.clear();
        }

        /// Обновляем списки
        ///
        if (todosList.isNotEmpty) {
          /// на сервере
          await remoteDataSource.updateTodos(todos: todosList);

          /// в локальной базе
          ///
          await localDataSource.updateTodos(todos: todosList);
        }

        /// В итоге получили актуальный список задач везде
      }
    } else {
      /// С сервера задач нет
      ///
      todosList.addAll(localTodosList);
      if (localTodosList.isNotEmpty) {
        await remoteDataSource.updateTodos(todos: todosList);
      }
    }
    return todosList;
  }

  /// SAVE Todo
  ///
  Future<Todo> saveTodo({required Todo todo}) async {
    log.info('Save Todo id: ${todo.uuid} ...');
    Todo? task;
    if (todo.autor == null) {
      todo = todo.copyWith(autor: deviceId);
    }
    if (await networkInfo.isConnected) {
      log.info('Save Todo id: ${todo.uuid} to Server ...');
      if (todo.upload) {
        task = await remoteDataSource.updateTodo(todo: todo);
      } else {
        task = await remoteDataSource.saveTodo(todo: todo);
      }
      log.info('Save Todo upload: ${task.upload}');
    }
    task ??= Todo.copyFrom(todo);
    try {
      await localDataSource.saveTodo(todo: task);
      log.info('Save Todo uuid: ${task.uuid} to DB upload: ${task.upload}');
    } on DBException {
      log.warning('Save Todo uuid: ${task.uuid}');
    }
    return task;
  }

  /// DELETE Todo
  ///
  Future<void> deleteTodo({required Todo todo}) async {
    log.info('Delete remote todo uuid: ${todo.uuid} ...');
    bool deleted = await remoteDataSource.deleteTodo(todo: todo);
    log.info('Delete remote todo');
    try {
      log.info('Delete local todo uuid: ${todo.uuid} ...');
      if (deleted) {
        await localDataSource.deleteTodo(todo: todo);
      } else {
        localDataSource.saveTodo(todo: todo.copyWith(deleted: true));
      }
      log.info('Delete local todo');
    } on DBException {
      log.warning('Delete local todo uuid: ${todo.uuid}');
    }
  }
}
