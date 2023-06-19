import 'package:logging/logging.dart';

import '../../domain/models/task.dart';
import '../db/isar_database.dart';
import 'impl_data_source.dart';
// import '../db/sql_database.dart';

final Logger log = Logger('LocalDataSource');

class TaskLocalDataSource implements ImplTaskDataSource {
  @override
  Future<List<TaskModel>> getTasks() async {
    log.info('Get Tasks ...');
    final List<TaskModel> tasksList = await DBProvider.db.getTasks();
    log.info('Get ${tasksList.length} tasks');
    return Future.value(tasksList);
  }

  @override
  Future<TaskModel> saveTask({required TaskModel task}) async {
    log.info('Save task uuid: ${task.uuid} ...');
    await DBProvider.db.saveTask(task: task);
    log.info('Save task ok?');
    return task;
  }

  @override
  Future<TaskModel> updateTask({required TaskModel task}) async {
    log.info('Update Task uuid: ${task.uuid} ...');
    await DBProvider.db.saveTask(task: task);
    log.info('Update Task ok?');
    return task;
  }

  @override
  Future<void> deleteTask({required TaskModel task}) async {
    log.info('Delete Task uuid: ${task.uuid} ...');
    await DBProvider.db.deleteTask(task: task);
    log.info('Delete Task ok?');
  }
}
