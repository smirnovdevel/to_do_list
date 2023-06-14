import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/core/logging.dart';

import '../data/repositories/task_repository.dart';
import '../di.dart';
import '../models/task.dart';

part 'task_event.dart';
part 'task_state.dart';

final log = logger(TaskBloc);

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepositoryImpl _taskRepositoryImpl = getIt();

  TaskBloc() : super(TasksEmpty()) {
    on<TasksInit>(
      (event, emit) async {
        log.i('loading tasks ...');
        emit(TasksLoading());
        final tasksList = await _taskRepositoryImpl.getAllTask();
        log.d('loaded ${tasksList.length} tasks');
        emit(TasksLoaded(tasksList));
      },
    );
    on<UpdateTask>(
      (event, emit) async {
        log.i('update task id: ${event.task.id} ...');
        await _taskRepositoryImpl.updateTask(task: event.task);
        log.i('update task id: ${event.task.id}');
        emit(TasksEmpty());
      },
    );
    on<DeleteTask>(
      (event, emit) async {
        log.i('delete task id: ${event.task.id} ...');
        await _taskRepositoryImpl.deleteTaskByID(id: event.task.id);
        log.d('delete task id: ${event.task.id}');
        emit(TasksEmpty());
      },
    );
  }
}
