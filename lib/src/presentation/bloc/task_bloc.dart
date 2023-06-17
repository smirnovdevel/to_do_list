import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../domain/repositories/task_repository.dart';
import '../../locator.dart';

import 'task_event.dart';
import 'task_state.dart';

// part 'task_event.dart';
// part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository = locator();

  final log = Logger('TaskBloc');

  TaskBloc() : super(TasksEmpty()) {
    on<TasksInit>(
      (event, emit) async {
        log.info('loading tasks ...');
        emit(TasksLoading());
        final tasksList = await _taskRepository.getAllTask();
        log.info('loaded ${tasksList.length} tasks');
        emit(TasksLoaded(tasksList));
      },
    );
    on<UpdateTask>(
      (event, emit) async {
        log.info('update task id: ${event.task.id} ...');
        await _taskRepository.updateTask(task: event.task);
        log.info('update task id: ${event.task.id}');
        // emit(TasksEmpty());
      },
    );
    on<DeleteTask>(
      (event, emit) async {
        log.info('delete task id: ${event.task.id} ...');
        try {
          await _taskRepository.deleteTask(task: event.task);
          log.info('delete task id: ${event.task.id}');
        } catch (e) {
          log.warning('delete task id: ${event.task.id} ${e.toString()}');
        }
        // emit(TasksEmpty());
      },
    );
  }
}
