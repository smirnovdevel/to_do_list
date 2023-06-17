import 'package:logging/logging.dart';

import '../../domain/models/task.dart';
import '../db/task_database.dart';

final log = Logger('TaskLocalDataSource');

abstract class ITaskLocalDataSource {
  Future<List<TaskModel>> getAllTasksFromDB();
  Future<void> insertTaskInDB({required TaskModel task});
  Future<void> deleteTaskByID({required String id});
}

class TaskLocalDataSource implements ITaskLocalDataSource {
  @override
  Future<List<TaskModel>> getAllTasksFromDB() async {
    log.info('get tasks ...');
    final tasksList = await DBProvider.db.getAllTasksFromDB();
    log.info('get ${tasksList.length} tasks');
    return Future.value(tasksList);
  }

  @override
  Future<void> insertTaskInDB({required TaskModel task}) async {
    log.info('insert task id: ${task.id} ...');
    await DBProvider.db.insertTask(task);
    log.info('insert task id: ${task.id}');
  }

  @override
  Future<void> deleteTaskByID({required String id}) async {
    log.info('delete task id: $id ...');
    await DBProvider.db.deleteTaskByID(id: id);
    log.info('delete task id: $id');
  }
}
