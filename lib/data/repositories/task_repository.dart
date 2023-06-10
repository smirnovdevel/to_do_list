import 'dart:developer' as console;

import 'package:to_do_list/bloc/task_bloc.dart';
import 'package:to_do_list/core/error/exception.dart';

import '../../models/task.dart';
import '../datasources/task_local_data_source.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getAllTask();
  updateTask({required TaskModel task});
}

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSourceImpl localDataSource;

  TaskRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<TaskModel>> getAllTask() async {
    List<TaskModel> localTasksList = [];
    console.log(
        '\u001b[1;33m Task repository: \u001b[1;34m getTaskByStatus \u001b[0m start');
    try {
      localTasksList = await localDataSource.getAllTasksFromDB();
    } on DBException {
      console.log(
          '\u001b[1;33m Task repository: \u001b[1;34m getTaskByStatus \u001b[0m start');
    }
    console.log(
        '\u001b[1;33m Task repository: \u001b[1;34m getTaskByStatus \u001b[0m load from DB: \u001b[1;32m ${localTasksList.length}');
    return localTasksList;
  }

  @override
  Future updateTask({required TaskModel task}) async {
    console.log(
        '\u001b[1;33m Task repository: \u001b[1;34m updateTask \u001b[0m start');
    try {
      await localDataSource.insertTaskInDB(task: task);
    } on DBException {
      console.log(
          '\u001b[1;33m Task repository: \u001b[1;34m updateTaskInDB \u001b[0m error');
    }
  }
}
