// part of 'task_bloc.dart';

import '../../domain/models/task.dart';

abstract class TaskEvent {
  const TaskEvent();
}

class TasksInit extends TaskEvent {}

class SaveTask extends TaskEvent {
  SaveTask({required this.task});
  final TaskModel task;
}

class DeleteTask extends TaskEvent {
  DeleteTask({required this.task});
  final TaskModel task;
}

class TasksUpdating extends TaskEvent {
  TasksUpdating();
}
