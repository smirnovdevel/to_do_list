import 'package:logging/logging.dart';

import '../../domain/models/task.dart';
import '../db/isar_database.dart';
// import '../db/sql_database.dart';

final Logger log = Logger('TaskLocalDataSource');

abstract class ITaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> saveTask({required TaskModel task});
  Future<void> deleteTask({required TaskModel task});
}

class TaskLocalDataSource implements ITaskLocalDataSource {
  @override
  Future<List<TaskModel>> getTasks() async {
    log.info('get tasks ...');
    final List<TaskModel> tasksList = await DBProvider.db.getTasks();
    log.info('get ${tasksList.length} tasks');
    return Future.value(tasksList);
  }

  @override
  Future<void> saveTask({required TaskModel task}) async {
    log.info('insert task uuid: ${task.uuid} ...');
    await DBProvider.db.saveTask(task: task);
    log.info('insert task uuid: ${task.uuid}');
  }

  @override
  Future<void> deleteTask({required TaskModel task}) async {
    log.info('delete task uuid: ${task.uuid} ...');
    await DBProvider.db.deleteTask(task: task);
    log.info('delete task uuid: ${task.uuid}');
  }
}
