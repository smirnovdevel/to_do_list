import '../../core/logging.dart';
import '../../models/task.dart';
import '../db/task_database.dart';

final log = logger(TaskLocalDataSource);

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasksFromDB();
  Future<void> insertTaskInDB({required TaskModel task});
  Future<void> deleteTaskByID({required int id});
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  @override
  Future<List<TaskModel>> getAllTasksFromDB() async {
    log.i('get tasks ...');
    final tasksList = await DBProvider.db.getAllTasksFromDB();
    log.d('get ${tasksList.length} tasks');
    return Future.value(tasksList);
  }

  @override
  Future<void> insertTaskInDB({required TaskModel task}) async {
    log.i('insert task id: ${task.id} ...');
    await DBProvider.db.insertTask(task);
    log.d('insert task id: ${task.id}');
  }

  @override
  Future<void> deleteTaskByID({required int id}) async {
    log.i('delete task id: $id ...');
    await DBProvider.db.deleteTaskByID(id: id);
    log.d('delete task id: $id');
  }
}
