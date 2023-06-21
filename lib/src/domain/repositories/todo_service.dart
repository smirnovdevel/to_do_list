import 'package:logging/logging.dart';

import '../../data/datasources/local_data_source.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/repositories/device_id.dart';
import '../../utils/core/network_info.dart';
import '../../utils/error/exception.dart';
import '../models/todo.dart';

/// Логика получения задач
/// Получаем задачи с сервера, считываем задачи из базы, синхронизируем их по UUID
///
/// Возможны следующие случаи:
///
/// 1) Задача есть на сервере, но её нет в базе.
/// Например: Создана на другом устройстве или грохнули базу
/// -- Добавляем в список, записываем в базу, присваиваем ID, upload = true
///
/// 2) Задача есть на сервере, задача есть в базе, но в время последнего изменения больше задачи с сервере, upload = true
/// Например: На телефоне не было интернета
/// -- а. Если задача из базы в статусе DELETED - удаляем задачу с сервера, удаляем задачу из базы
/// -- b. Добавляем задачу в список, обновляем задачу на сервере
///
/// 3: Задача есть базе, но её нет на сервере, upload = false
/// Например: На телефоне не было интернета
/// -- Добавляем в список, отправляем задачу на сервере, upload = true, обновляем задачу в базе
///
/// 4) Задача есть на сервере, задача есть в базе, но в время последнего изменения меньше задачи с сервере, upload = true
/// Например: Была изменена с другого устройства
/// -- Добавляем в список, обновляем задачу в базе
///
/// 5) Задача есть базе, но её нет на сервере, upload = true
/// Например: Задача удалена с другого устройства
/// -- удаляем задачу из базы
///
/// 6) Задача есть и там, время последнего измения совпадает
/// -- Добавляем в список
///
final Logger log = Logger('TodoService');

class TodoService {
  TodoService({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  final ITodoRemoteDataSource remoteDataSource;
  final ITodoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  String? deviceId;

  Future<void> getId() async {
    deviceId = await getDeviceID();
    log.info('Device id: $deviceId');
  }

  /// GET All Todo
  ///
  Future<List<Todo>> getTodos() async {
    List<Todo> localTodosList = [];
    List<Todo> remoteTodosList = [];
    List<Todo> todosList = [];

    /// check internet connection
    log.info('Get Todos from Server...');
    if (await networkInfo.isConnected) {
      remoteTodosList = await remoteDataSource.getTodos();
      if (remoteTodosList.isNotEmpty) {
        log.info('Get ${remoteTodosList.length} from Server');
      }
    } else {
      log.warning('No Internet connection');
    }
    log.info('Get Todos from DB...');
    try {
      localTodosList = await localDataSource.getTodos();
      log.info('Get ${localTodosList.length} todos from DB');
    } on DBException {
      log.warning('Get Todos from DB');
    }

    /// Проверям даты последнего изменения задачи, по последней истинная
    if (remoteTodosList.isNotEmpty) {
      if (localTodosList.isEmpty) {
        for (Todo todo in remoteTodosList) {
          await localDataSource.saveTodo(todo: todo);
          todosList.add(todo);
        }
      } else {
        // Перебираем все задания с сервера
        for (final Todo remoteTodo in remoteTodosList) {
          /// Ищем задачу с этим UUID в списке полученных из базы
          try {
            Todo localTodo = localTodosList
                .firstWhere((Todo item) => item.uuid == remoteTodo.uuid);
            // задача найдена, проверяем время послднегео обновления
            if (localTodo.changed.isBefore(remoteTodo.changed)) {
              /// Вариант 4.
              todosList.add(Todo.copyFrom(remoteTodo));
              await localDataSource.saveTodo(todo: todosList.last);
            } else if (remoteTodo.changed.isBefore(localTodo.changed)) {
              /// Вариант 2.
              if (localTodo.deleted) {
                /// случай а
                await remoteDataSource.deleteTodo(todo: localTodo);
              } else {
                /// случай b
                await remoteDataSource.updateTodo(todo: localTodo);
                if (localTodo.upload) {
                  log.info('Update todo id: ${localTodo.uuid} ...');
                  await localDataSource.saveTodo(todo: localTodo);
                }
                todosList.add(Todo.copyFrom(localTodo));
              }
            } else {
              /// Вариант 6.
              todosList.add(Todo.copyFrom(localTodo));
            }
            localTodosList.removeWhere((todo) => todo.uuid == remoteTodo.uuid);
          } on StateError catch (_) {
            /// Задачи полученной с сервера нет в списке поз лученных из базы
            /// Вариант 1.
            todosList.add(Todo.copyFrom(remoteTodo));
            await localDataSource.saveTodo(todo: todosList.last);
          }
          localTodosList
              .removeWhere((Todo item) => item.uuid == remoteTodo.uuid);
        }
        // В localTodosList остались задачи которых нет на сервере
        if (localTodosList.isNotEmpty) {
          log.info('found ${localTodosList.length} not upload todos');
        }
        for (final Todo todo in localTodosList) {
          if (todo.upload) {
            /// Вариант 5.
            await localDataSource.deleteTodo(todo: todo);
          } else {
            /// Вариант 5.
            todosList.add(todo);
            log.info('Upload Todo id: ${todo.uuid} ...');
            await remoteDataSource.saveTodo(todo: todo);
            // при успешной отправке, обновляем в базе с новым статусом
            if (todo.upload) {
              log.info('Update Todo id: ${todo.uuid} ...');
              await localDataSource.saveTodo(todo: todo);
            }
          }
        }
        // все задачи должны быть разобраны
      }
    } else {
      // с сервера задач нет
      todosList.addAll(localTodosList);
    }
    return todosList;
  }

  /// SAVE Todo
  ///
  Future<Todo> saveTodo({required Todo todo}) async {
    log.info('Save Todo id: ${todo.uuid} ...');
    if (todo.autor == null) {
      todo = todo.copyWith(autor: deviceId);
    }
    if (await networkInfo.isConnected) {
      if (todo.upload) {
        log.info('Update Todo id: ${todo.uuid} to Server');
        await remoteDataSource.updateTodo(todo: todo);
        log.info('Update Todo upload: ${todo.upload}');
      } else {
        log.info('Save Todo id: ${todo.uuid} to Server');
        todo = await remoteDataSource.saveTodo(todo: todo);
        log.info('Save Todo upload: ${todo.upload}');
      }
    }
    try {
      await localDataSource.saveTodo(todo: todo);
      log.info('Save Todo uuid: ${todo.uuid} to DB upload: ${todo.upload}');
    } on DBException {
      log.warning('Save Todo uuid: ${todo.uuid}');
    }
    return todo;
  }

  /// DELETE Todo
  ///
  Future<int?> deleteTodo({required Todo todo}) async {
    log.info('delete todo uuid: ${todo.uuid} ...');
    if (todo.upload) {
      await remoteDataSource.deleteTodo(todo: todo);
    }
    try {
      await localDataSource.deleteTodo(todo: todo);
      log.info('delete todo uuid: ${todo.uuid}');
    } on DBException {
      log.warning('delete todo uuid: ${todo.uuid}');
    }
    return null;
  }
}
