import 'package:to_do_list/core/error/exception.dart';

import '../../core/logging.dart';
import '../../models/task.dart';
import '../datasources/task_local_data_source.dart';

final log = logger(TaskRepository);

abstract class TaskRepository {
  Future<List<TaskModel>> getAllTask();
  Future<TaskModel> updateTask({required TaskModel task});
  Future<int?> deleteTaskByID({required int id});
}

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSourceImpl localDataSource;

  TaskRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<TaskModel>> getAllTask() async {
    List<TaskModel> localTasksList = [];
    log.i('get tasks from DB...');
    try {
      localTasksList = await localDataSource.getAllTasksFromDB();
      log.d('get ${localTasksList.length} tasks from DB');
    } on DBException {
      log.e('get task from DB tasks');
    }
    return localTasksList;
  }

  @override
  Future<TaskModel> updateTask({required TaskModel task}) async {
    log.i('update task id: ${task.id} ...');
    try {
      await localDataSource.insertTaskInDB(task: task);
      log.d('update task id: ${task.id}');
    } on DBException {
      log.e('update task id: ${task.id}');
    }
    return task;
  }

  @override
  Future<int?> deleteTaskByID({required int id}) async {
    log.d('delete task id: $id ...');
    try {
      await localDataSource.deleteTaskByID(id: id);
      log.d('delete task id: $id');
    } on DBException {
      log.e('delete task id: $id');
    }
    return null;
  }
}
