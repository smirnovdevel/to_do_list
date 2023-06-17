import 'package:logging/logging.dart';
import 'package:to_do_list/core/error/exception.dart';
import 'package:to_do_list/data/datasources/task_remote_data_source.dart';

import '../../core/network_info.dart';
import '../../models/task.dart';
import '../datasources/task_local_data_source.dart';

abstract class ITaskRepository {
  Future<List<TaskModel>> getAllTask();
  Future<TaskModel> updateTask({required TaskModel task});
  Future<int?> deleteTaskByID({required String id});
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

  /// Получение с сервера списка задач
  ///
  /// 1. После получения сравниваем со списком в базе
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
      log.info('no internet connection');
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
        for (TaskModel remoteTask in remoteTasksList) {
          /// Task with id found in DB
          try {
            TaskModel localTask =
                localTasksList.firstWhere((item) => item.id == remoteTask.id);
            if (localTask.changed.isBefore(remoteTask.changed)) {
              localTask = remoteTask;
              localTask.upload = true;
              tasksList.add(localTask);
              updateTask(task: localTask);
            }
          } on StateError catch (_) {
            TaskModel localTask = remoteTask;
            localTask.upload = true;
            tasksList.add(localTask);
            updateTask(task: localTask);
          }
        }
      }
    }
    return tasksList;
  }

  @override
  Future<TaskModel> updateTask({required TaskModel task}) async {
    if (await networkInfo.isConnected) {
      log.info('add ${task.id} to Server');
      await remoteDataSource.postTaskToServer(task: task);
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

  @override
  Future<int?> deleteTaskByID({required String id}) async {
    log.info('delete task id: $id ...');
    try {
      await localDataSource.deleteTaskByID(id: id);
      log.info('delete task id: $id');
    } on DBException {
      log.warning('delete task id: $id');
    }
    return null;
  }
}
