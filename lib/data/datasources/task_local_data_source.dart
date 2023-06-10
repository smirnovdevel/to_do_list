import 'dart:developer' as console;

import '../../core/error/exception.dart';
import '../../models/task.dart';
import '../db/task_database.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasksFromDB();
  Future<void> insertTaskInDB({required TaskModel task});
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  @override
  Future<List<TaskModel>> getAllTasksFromDB() async {
    final tasksList = await DBProvider.db.getAllTasksFromDB();
    if (tasksList.isNotEmpty) {
      console.log(
          '\u001b[1;33m Task DB source: \u001b[1;34m getAllTasksFromDB \u001b[0m records: \u001b[1;32m ${tasksList.length}');
      return Future.value(tasksList);
    } else {
      throw DBException();
    }
  }

  @override
  Future<TaskModel> insertTaskInDB({required TaskModel task}) {
    DBProvider.db.insertTask(task);
    console.log(
        '\u001b[1;33m Task DB source: \u001b[1;34m updateTaskToDB \u001b[0m task \u001b[1;32m ${task.id}');
    return Future.value(task);
  }
}
