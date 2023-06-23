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
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  String? deviceId;

  Future<void> getId() async {
    deviceId = await getDeviceID();
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
      /// Удаляем с сервеа все таски, помеченные в базе на удаление
      ///
      List<Todo> todosDeletedList = await localDataSource.getDeletedTodos();
      for (Todo todo in todosDeletedList) {
        bool deleted = await remoteDataSource.deleteTodo(todo: todo);
        if (deleted) {
          await localDataSource.deleteTodo(todo: todo);
        }
      }

      /// Получаем чистый список задач с сервера
      ///
      List<Todo> remoteTodosList = await remoteDataSource.getTodos();
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
      if (localTodosList.isEmpty) {
        for (Todo todo in remoteTodosList) {
          localDataSource.saveTodo(todo: todo);
          todosList.add(todo);
        }
      } else {
        /// Для быстрого поиска составим две мапы
        ///
        Map<String, DateTime> remoteTodosMap = {
          for (var todo in remoteTodosList) todo.uuid!: todo.changed
        };
        Map<String, DateTime> localeTodosMap = {
          for (var todo in localTodosList) todo.uuid!: todo.changed
        };

        /// Перебираем все задания с сервера и сравниваем с теми, что загружены из базы
        ///
        for (String uuid in remoteTodosMap.keys) {
          if (localeTodosMap.containsKey(uuid)) {
            /// такая задача в базе есть
            ///
            if (localeTodosMap[uuid]!.isBefore(remoteTodosMap[uuid]!)) {
              // на сервере версия свежее
              todosList
                  .addAll(remoteTodosList.where((todo) => todo.uuid == uuid));
            } else {
              // в базе версия свежее
              todosList
                  .addAll(localTodosList.where((todo) => todo.uuid == uuid));
            }
            localeTodosMap.remove(uuid);
            remoteTodosMap.remove(uuid);
          } else {
            /// такой задачи в базе нет
            ///
            todosList
                .addAll(remoteTodosList.where((todo) => todo.uuid == uuid));
          }
        }

        /// Возможно, в базе есть задачи, которых нет на сервере, добавляем в список
        ///
        for (String uuid in localeTodosMap.keys) {
          todosList.addAll(localTodosList.where((todo) => todo.uuid == uuid));
        }

        /// В итоге получили актуальный список задач, обновим его в базе и на сервере
        ///
        bool status = await remoteDataSource.updateTodos(todos: todosList);
        if (status) {
          await localDataSource.updateTodos(todos: todosList);
        }
      }
    } else {
      // с сервера задач нет
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
      if (todo.upload) {
        log.info('Save Todo id: ${todo.uuid} to Server');
        task = await remoteDataSource.updateTodo(todo: todo);
        log.info('Save Todo upload: ${task.upload}');
      } else {
        log.info('Save Todo id: ${todo.uuid} to Server');
        task = await remoteDataSource.saveTodo(todo: todo);
        log.info('Save Todo upload: ${task.upload}');
      }
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
