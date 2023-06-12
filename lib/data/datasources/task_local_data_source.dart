import '../../core/logging.dart';
import '../../models/task.dart';
import '../db/task_database.dart';

final log = logger(TaskLocalDataSource);

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasksFromDB();
  Future<void> insertTaskInDB({required TaskModel task});
  Future<void> deleteTaskFromDB({required TaskModel task});
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
  Future<TaskModel> insertTaskInDB({required TaskModel task}) {
    log.i('insert task id: ${task.id} ...');
    DBProvider.db.insertTask(task);
    log.d('insert task id: ${task.id}');
    return Future.value(task);
  }

  @override
  Future<TaskModel> deleteTaskFromDB({required TaskModel task}) {
    log.i('delete task id: ${task.id} ...');
    DBProvider.db.deleteTask(id: task.id);
    log.d('delete task id: ${task.id}');
    return Future.value(task);
  }
}
