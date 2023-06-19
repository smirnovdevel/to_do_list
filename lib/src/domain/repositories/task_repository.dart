import 'package:logging/logging.dart';

import '../../data/datasources/local_data_source.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../utils/core/network_info.dart';
import '../../utils/error/exception.dart';
import '../models/task.dart';

abstract class ITaskRepository {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> saveTask({required TaskModel task});
  Future<int?> deleteTask({required TaskModel task});
}

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
final Logger log = Logger('TaskRepository');

class TaskRepository implements ITaskRepository {
  TaskRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  /// GET All Task
  ///
  @override
  Future<List<TaskModel>> getTasks() async {
    List<TaskModel> localTasksList = [];
    List<TaskModel> remoteTasksList = [];
    List<TaskModel> tasksList = [];

    /// check internet connection
    log.info('Get Tasks from Server...');
    if (await networkInfo.isConnected) {
      remoteTasksList = await remoteDataSource.getTasks();
      if (remoteTasksList.isNotEmpty) {
        log.info('get ${remoteTasksList.length} from Server');
      }
    } else {
      log.warning('No Internet connection');
    }
    log.info('Get Tasks from DB...');
    try {
      localTasksList = await localDataSource.getTasks();
      log.info('Get ${localTasksList.length} tasks from DB');
    } on DBException {
      log.warning('Get Tasks from DB');
    }

    /// Проверям даты последнего изменения задачи, по последней истинная
    if (remoteTasksList.isNotEmpty) {
      if (localTasksList.isEmpty) {
        for (TaskModel task in remoteTasksList) {
          await localDataSource.saveTask(task: task);
          tasksList.add(task);
        }
      } else {
        // Перебираем все задания с сервера
        for (final TaskModel remoteTask in remoteTasksList) {
          /// Ищем задачу с этим UUID в списке полученных из базы
          try {
            TaskModel localTask = localTasksList
                .firstWhere((TaskModel item) => item.uuid == remoteTask.uuid);
            // задача найдена, проверяем время послднегео обновления
            if (localTask.changed.isBefore(remoteTask.changed)) {
              /// Вариант 4.
              tasksList.add(TaskModel.copyFrom(remoteTask));
              await localDataSource.saveTask(task: tasksList.last);
            } else if (remoteTask.changed.isBefore(localTask.changed)) {
              /// Вариант 2.
              if (localTask.deleted) {
                /// случай а
                await remoteDataSource.deleteTask(task: localTask);
              } else {
                /// случай b
                localTask.upload = false;
                await remoteDataSource.updateTask(task: localTask);
                if (localTask.upload) {
                  log.info('Update task id: ${localTask.uuid} ...');
                  await localDataSource.saveTask(task: localTask);
                }
                tasksList.add(TaskModel.copyFrom(localTask));
              }
            } else {
              /// Вариант 6.
              tasksList.add(TaskModel.copyFrom(localTask));
            }
            localTasksList.removeWhere((task) => task.uuid == remoteTask.uuid);
          } on StateError catch (_) {
            /// Задачи полученной с сервера нет в списке поз лученных из базы
            /// Вариант 1.
            tasksList.add(TaskModel.copyFrom(remoteTask));
            await localDataSource.saveTask(task: tasksList.last);
          }
          localTasksList
              .removeWhere((TaskModel item) => item.uuid == remoteTask.uuid);
        }
        // В localTasksList остались задачи которых нет на сервере
        if (localTasksList.isNotEmpty) {
          log.info('found ${localTasksList.length} not upload tasks');
        }
        for (final TaskModel task in localTasksList) {
          if (task.upload) {
            /// Вариант 5.
            await localDataSource.deleteTask(task: task);
          } else {
            /// Вариант 5.
            tasksList.add(task);
            log.info('Upload Task id: ${task.uuid} ...');
            await remoteDataSource.saveTask(task: task);
            // при успешной отправке, обновляем в базе с новым статусом
            if (task.upload) {
              log.info('Update Task id: ${task.uuid} ...');
              await localDataSource.saveTask(task: task);
            }
          }
        }
        // все задачи должны быть разобраны
      }
    } else {
      // с сервера задач нет
      tasksList.addAll(localTasksList);
    }
    return tasksList;
  }

  /// SAVE Task
  ///
  @override
  Future<TaskModel> saveTask({required TaskModel task}) async {
    log.info('Save Task id: ${task.uuid} ...');
    if (await networkInfo.isConnected) {
      if (task.upload) {
        log.info('Update Task id: ${task.uuid} to Server');
        await remoteDataSource.updateTask(task: task);
      } else {
        log.info('Save Task id: ${task.uuid} to Server');
        await remoteDataSource.saveTask(task: task);
      }
    }
    try {
      await localDataSource.saveTask(task: task);
      log.info('Save Task uuid: ${task.uuid} to DB upload: ${task.upload}');
    } on DBException {
      log.warning('Save Task uuid: ${task.uuid}');
    }
    return task;
  }

  /// DELETE Task
  ///
  @override
  Future<int?> deleteTask({required TaskModel task}) async {
    log.info('delete task uuid: ${task.uuid} ...');
    if (task.upload) {
      await remoteDataSource.deleteTask(task: task);
    }
    try {
      await localDataSource.deleteTask(task: task);
      log.info('delete task uuid: ${task.uuid}');
    } on DBException {
      log.warning('delete task uuid: ${task.uuid}');
    }
    return null;
  }
}
