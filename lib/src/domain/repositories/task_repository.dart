import 'package:logging/logging.dart';

import '../../data/datasources/task_local_data_source.dart';
import '../../data/datasources/task_remote_data_source.dart';
import '../../utils/core/network_info.dart';
import '../../utils/error/exception.dart';
import '../models/task.dart';

abstract class ITaskRepository {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> saveTask({required TaskModel task});
  Future<int?> deleteTask({required TaskModel task});
}

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
    log.info('get tasks from Server...');
    if (await networkInfo.isConnected) {
      remoteTasksList = await remoteDataSource.getAllTasksFromServer();
      if (remoteTasksList.isNotEmpty) {
        log.info('get ${remoteTasksList.length} from Server');
      }
    } else {
      log.warning('no internet connection');
    }
    log.info('get tasks from DB...');
    try {
      localTasksList = await localDataSource.getTasks();
      log.info('get ${localTasksList.length} tasks from DB');
    } on DBException {
      log.warning('get task from DB tasks');
    }

    /// Проверям даты последнего изменения задачи, по последней истинная
    if (remoteTasksList.isNotEmpty) {
      if (localTasksList.isEmpty) {
        tasksList.addAll(remoteTasksList);
      } else {
        /// Все задачи загруженные из базы копируем во временный список
        /// для разбора

        /// Перебираем все задания с сервера
        for (final TaskModel remoteTask in remoteTasksList) {
          /// Задача с этим ID есть в базе
          try {
            TaskModel localTask = localTasksList
                .firstWhere((TaskModel item) => item.uuid == remoteTask.uuid);

            // задача есть на сервере и в локальной базе
            // если время последнего изменения на сервере больше
            // чем в локальной, добавляем в список и обновляем в базе
            //
            if (localTask.changed.isBefore(remoteTask.changed)) {
              localTask = TaskModel.copyFrom(remoteTask);
              tasksList.add(localTask);
              saveTask(task: localTask);

              // задача есть и на сервере и в базе
              // дата последнего обновления совпадает
              // просто добавляем в список
            } else {
              tasksList.add(localTask);
            }
          } on StateError catch (_) {
            // задачи нет в локальной базе, добавляем
            final TaskModel localTask = TaskModel.copyFrom(remoteTask);
            tasksList.add(localTask);
            saveTask(task: localTask);
          }
          localTasksList
              .removeWhere((TaskModel item) => item.uuid == remoteTask.uuid);
        }
        // если остались задачи, загруженные из базы, есть 2 варианта
        for (final TaskModel task in localTasksList) {
          // 1 - их удалили с другого устройства, удаляем из базы
          //
          if (task.upload) {
            deleteTask(task: task);
          } else {
            // 2 - они не загружены на сервере
            //
            tasksList.add(task);
            log.info('get ${localTasksList.length} found not upload task');
            remoteDataSource.postTaskToServer(task: task);
          }
          // все задачи разобраны, очищаем на всякий случай
          // localTasksList.clear();
        }
      }
    }
    return tasksList;
  }

  /// SAVE Task
  ///
  @override
  Future<TaskModel> saveTask({required TaskModel task}) async {
    if (await networkInfo.isConnected) {
      // если задача уже загружена на сервер обновляем
      // иначе добавляем
      if (task.upload) {
        log.info('add ${task.uuid} to Server');
        await remoteDataSource.updateTaskToServer(task: task);
      } else {
        log.info('add ${task.uuid} to Server');
        await remoteDataSource.postTaskToServer(task: task);
      }
    }
    log.info('update task uuid: ${task.uuid} ...');
    try {
      await localDataSource.saveTask(task: task);
      log.info('update task uuid: ${task.uuid} upload: ${task.upload}');
    } on DBException {
      log.warning('update task uuid: ${task.uuid}');
    }
    return task;
  }

  /// DELETE Task
  ///
  @override
  Future<int?> deleteTask({required TaskModel task}) async {
    log.info('delete task uuid: ${task.uuid} ...');
    if (task.upload) {
      await remoteDataSource.deleteTaskFromServer(task: task);
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
