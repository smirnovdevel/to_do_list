// part of 'task_bloc.dart';

import '../../domain/models/task.dart';

abstract class TaskEvent {
  const TaskEvent();
}

class TasksInit extends TaskEvent {}

class UpdateTask extends TaskEvent {
  final TaskModel task;

  UpdateTask({required this.task});
}

class DeleteTask extends TaskEvent {
  final TaskModel task;

  DeleteTask({required this.task});
}
