import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import '../data/repositories/task_repository.dart';
import '../di.dart';
import '../models/task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepositoryImpl _taskRepositoryImpl = getIt();

  TaskBloc() : super(TasksEmpty()) {
    on<TasksInit>(
      (event, emit) async {
        developer
            .log('\u001b[1;33m TaskBloc: \u001b[1;34m init \u001b[0m start');
        emit(TasksLoading());
        final tasksList = await _taskRepositoryImpl.getAllTask();
        developer.log(
            '\u001b[1;33m TaskBloc: \u001b[1;34m init \u001b[0m load task: \u001b[1;32m ${tasksList.length}');
        emit(TasksLoaded(tasksList));
      },
    );
    on<UpdateTask>(
      (event, emit) async {
        developer.log(
            '\u001b[1;33m TaskBloc: \u001b[1;34m UpdateTask \u001b[0m task: \u001b[1;32m ${event.task.title}');
        await _taskRepositoryImpl.updateTask(task: event.task);
        emit(TasksEmpty());
      },
    );
  }
}
