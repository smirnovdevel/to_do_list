import 'package:flutter/foundation.dart';

import '../../data/datasources/local_data_source.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/utils/device_id.dart';
import '../../utils/core/logging.dart';
import '../../utils/exceptions/db_exception.dart';
import '../models/todo.dart';

final Logging log = Logging('TodoService');

/// Расширение класса int для сравнения времени в формате
/// unix timestamp
///
extension CompareUnixTimestamp on int {
  bool isAfter(int compare) {
    return DateTime.fromMillisecondsSinceEpoch(this)
        .isAfter(DateTime.fromMillisecondsSinceEpoch(compare));
  }

  bool isBefore(int compare) {
    return DateTime.fromMillisecondsSinceEpoch(this)
        .isBefore(DateTime.fromMillisecondsSinceEpoch(compare));
  }
}

class TodoService {
  TodoService({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  String? deviceId;

  Future<void> setAutor() async {
    deviceId ??= await getDeviceID();
    log.info('Device id: $deviceId');
  }

  /// GET Remote TodoList
  ///
  Future<List<Todo>> getRemoteTodosList() async {
    /// Получаем список задач с сервера
    ///
    log.info('Get Todos from Server...');
    List<Todo> remoteTodosList = await remoteDataSource.getTodos();
    log.info('Get ${remoteTodosList.length} from Server');
    return remoteTodosList;
  }

  /// GET Local TodoList
  ///
  Future<List<Todo>> getLocalTodosList() async {
    /// Получаем список задач из базы данных
    ///
    List<Todo>? localTodosList;
    log.info('Get Todos from DB...');
    if (!kIsWeb) {
      localTodosList = await localDataSource.getTodos();
      log.info('Get ${localTodosList.length} todos from DB');
    }
    return localTodosList ??= [];
  }

  /// GET All Todos
  ///
  Future<List<Todo>> matchingTodos(
      {required List<Todo> local, required List<Todo> remote}) async {
    List<Todo> todosList = [];

    log.info('Matching...');

    /// Проверям даты последнего изменения задачи, по последней истинная
    ///
    if (remote.isNotEmpty) {
      /// C сервера получены какие-то задачи
      ///
      if (local.isEmpty) {
        /// База пустая
        ///
        if (!kIsWeb) {
          await localDataSource.updateTodos(todos: remote);
        }
        for (Todo todo in remote) {
          todosList.add(todo.copyWith(upload: true));
        }
      } else {
        /// Есть список с сервера и есть список из базы,
        /// для быстрого поиска составим две мапы
        ///
        Map<String, int> remoteTodosMap = {
          for (var todo in remote) todo.uuid: todo.changed!
        };
        Map<String, int> localeTodosMap = {
          for (var todo in local) todo.uuid: todo.changed!
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
            Todo localTodo = local.firstWhere((todo) => todo.uuid == uuid);
            if (localeTodosMap[uuid]!.isBefore(remoteTodosMap[uuid]!)) {
              /// на сервере версия свежее, проверяем не удалена ли
              if (localTodo.deleted) {
                localDelete.add(localTodo);
              } else {
                todosList.add(remote.firstWhere((todo) => todo.uuid == uuid));
              }
            } else if (remoteTodosMap[uuid]!.isBefore(localeTodosMap[uuid]!)) {
              /// в базе версия свежее, проверяем не удалена ли
              if (localTodo.deleted) {
                localDelete.add(localTodo);
              } else {
                todosList.add(local.firstWhere((todo) => todo.uuid == uuid));
              }
            } else {
              /// записи совпадают, просто добавляем в список, берём версию с сервера
              /// там уже upload = true
              if (localTodo.deleted) {
                localDelete.add(localTodo);
              } else {
                todosList.add(local.firstWhere((todo) => todo.uuid == uuid));
              }
            }

            /// сохраняем совпадения
            uuidProcessed.add(uuid);
          } else {
            /// если такой задачи в базе нет, добавляем в общий список
            /// и список для обновления в базе
            todosList.addAll(remote.where((todo) => todo.uuid == uuid));
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
          localDelete
              .addAll(local.where((todo) => todo.uuid == uuid && todo.upload));
        }

        /// 2. Они не были выгружены на сервер и не удалены, upload = false, delete = false
        /// добавляем в общий список и список обновления на сервере
        for (String uuid in localeTodosMap.keys) {
          todosList.addAll(local.where(
              (todo) => todo.uuid == uuid && !todo.upload && !todo.deleted));
        }

        /// 3. Они не были выгружены на сервер и удалены, upload = false, delete = true
        /// удаляем из базы
        for (String uuid in localeTodosMap.keys) {
          localDelete.addAll(local.where(
              (todo) => todo.uuid == uuid && !todo.upload && todo.deleted));
        }

        /// Удаляем лишние таски из базы
        ///
        if (localDelete.isNotEmpty && !kIsWeb) {
          for (Todo todo in localDelete) {
            await localDataSource.deleteTodo(todo: todo);
          }
          localDelete.clear();
        }

        /// Обновляем в локальной базе
        ///
        if (todosList.isNotEmpty && !kIsWeb) {
          await localDataSource.updateTodos(todos: todosList);
        }
      }
    } else {
      todosList.addAll(local.where((todo) => !todo.deleted));
    }
    return todosList;
  }

  // UPLOAD Todos Remote
  ///
  Future<void> uploadTodosRemote({required List<Todo> todos}) async {
    log.info('Upload Todos ...');
    if (todos.isNotEmpty) {
      await remoteDataSource.updateTodos(todos: todos);
    }
    log.info('Upload Todos');
  }

  /// UPLOAD Todo Remote
  ///
  Future<Todo> uploadTodoRemote({required Todo todo}) async {
    log.info('Upload Todo id: ${todo.uuid} ...');
    Todo? task;
    if (todo.deviceId == null) {
      todo = todo.copyWith(deviceId: deviceId);
    }
    log.info('Upload Todo id: ${todo.uuid} to Server ...');
    if (todo.upload) {
      task = await remoteDataSource.updateTodo(todo: todo);
    } else {
      task = await remoteDataSource.saveTodo(todo: todo);
    }
    log.info('Upload Todo upload: ${task.upload}');

    return task;
  }

  /// SAVE Todo to DB
  ///
  Future<Todo> saveTodoDB({required Todo todo}) async {
    log.info('Save Todo id: ${todo.uuid} ...');

    /// DB not need to Web
    if (kIsWeb) {
      return todo;
    }
    try {
      if (todo.deviceId == null) {
        todo = todo.copyWith(deviceId: deviceId);
      }
      await localDataSource.saveTodo(todo: todo);
      log.info('Save Todo uuid: ${todo.uuid} to DB upload: ${todo.upload}');
    } on DBException {
      log.warning('Save Todo uuid: ${todo.uuid}');
    }
    return todo;
  }

  /// DELETE Todo Remote
  ///
  Future<bool> deleteTodoRemote({required Todo todo}) async {
    log.info('Delete remote todo uuid: ${todo.uuid} ...');
    bool result = await remoteDataSource.deleteTodo(todo: todo);
    log.info('Delete remote todo');
    return result;
  }

  /// DELETE Todo From DB
  ///
  Future<void> deleteTodoDB({required Todo todo, required bool deleted}) async {
    /// DB not need to Web
    if (kIsWeb) {
      return;
    }
    try {
      if (todo.deviceId == null) {
        todo = todo.copyWith(deviceId: deviceId);
      }
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
