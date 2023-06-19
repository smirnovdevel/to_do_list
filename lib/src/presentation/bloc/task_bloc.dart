import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../domain/models/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../locator.dart';

import 'task_event.dart';
import 'task_state.dart';

// part 'task_event.dart';
// part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TasksEmpty()) {
    on<TasksInit>(
      (TasksInit event, Emitter<TaskState> emit) async {
        log.info('loading tasks ...');
        emit(TasksLoading());
        final List<TaskModel> tasksList = await _taskRepository.getTasks();
        log.info('loaded ${tasksList.length} tasks');
        emit(TasksLoaded(tasksList));
      },
    );
    on<SaveTask>(
      (SaveTask event, Emitter<TaskState> emit) async {
        log.info('save task id: ${event.task.uuid} ...');
        await _taskRepository.saveTask(task: event.task);
        log.info('save task id: ${event.task.uuid}');
      },
    );
    on<DeleteTask>(
      (DeleteTask event, Emitter<TaskState> emit) async {
        log.info('delete task id: ${event.task.uuid} ...');
        await _taskRepository.deleteTask(task: event.task);
        log.info('delete task id: ${event.task.uuid}');
        emit(TaskDeleted(event.task));
      },
    );
    on<TasksUpdating>(
      (TasksUpdating event, Emitter<TaskState> emit) {
        log.info('task updated ...');
        emit(TasksUpdated());
      },
    );
  }
  final TaskRepository _taskRepository = locator();

  final Logger log = Logger('TaskBloc');
}
