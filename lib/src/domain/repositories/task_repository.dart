import 'package:logging/logging.dart';
import 'package:to_do_list/src/utils/error/exception.dart';
import 'package:to_do_list/src/data/datasources/task_remote_data_source.dart';

import '../../utils/core/network_info.dart';
import '../models/task.dart';
import '../../data/datasources/task_local_data_source.dart';

abstract class ITaskRepository {
  Future<List<TaskModel>> getAllTask();
  Future<TaskModel> updateTask({required TaskModel task});
  Future<int?> deleteTask({required TaskModel task});
}

final log = Logger('TaskRepository');

class TaskRepository implements ITaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TaskRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  /// GET All Task
  ///
  @override
  Future<List<TaskModel>> getAllTask() async {
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
      localTasksList = await localDataSource.getAllTasksFromDB();
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
        for (TaskModel remoteTask in remoteTasksList) {
          /// Задача с этим ID есть в базе
          try {
            TaskModel localTask =
                localTasksList.firstWhere((item) => item.id == remoteTask.id);

            // задача есть на сервере и в локальной базе
            // если время последнего изменения на сервере больше
            // чем в локальной, добавляем в список и обновляем в базе
            //
            if (localTask.changed.isBefore(remoteTask.changed)) {
              localTask = remoteTask;
              localTask.upload = true;
              tasksList.add(localTask);
              updateTask(task: localTask);

              // задача есть и на сервере и в базе
              // дата последнего обновления совпадает
              // просто добавляем в список
            } else {
              tasksList.add(localTask);
            }
          } on StateError catch (_) {
            // задачи нет в локальной базе, добавляем
            TaskModel localTask = remoteTask;
            localTask.upload = true;
            tasksList.add(localTask);
            updateTask(task: localTask);
          }
          localTasksList.removeWhere((item) => item.id == remoteTask.id);
        }
        // если остались задачи, загруженные из базы, есть 2 варианта
        for (TaskModel task in localTasksList) {
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
          localTasksList.clear();
        }
      }
    }
    return tasksList;
  }

  /// UPDATE Task
  ///
  @override
  Future<TaskModel> updateTask({required TaskModel task}) async {
    if (await networkInfo.isConnected) {
      // если задача уже загружена на сервер обновляем
      // иначе добавляем
      if (task.upload) {
        log.info('add ${task.id} to Server');
        await remoteDataSource.updateTaskToServer(task: task);
      } else {
        log.info('add ${task.id} to Server');
        await remoteDataSource.postTaskToServer(task: task);
      }
    }
    log.info('update task id: ${task.id} ...');
    try {
      await localDataSource.insertTaskInDB(task: task);
      log.info('update task id: ${task.id} upload: ${task.upload}');
    } on DBException {
      log.warning('update task id: ${task.id}');
    }
    return task;
  }

  /// DELETE Task
  ///
  @override
  Future<int?> deleteTask({required TaskModel task}) async {
    log.info('delete task id: ${task.id} ...');
    if (task.upload) {
      await remoteDataSource.deleteTaskFromServer(task: task);
    }
    try {
      await localDataSource.deleteTaskByID(id: task.id!);
      log.info('delete task id: ${task.id}');
    } on DBException {
      log.warning('delete task id: ${task.id}');
    }
    return null;
  }
}
