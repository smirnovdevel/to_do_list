// part of 'task_bloc.dart';

import 'package:equatable/equatable.dart';

import '../../domain/models/task.dart';

abstract class TaskState extends Equatable {}

// Начальное состояние
class TasksEmpty extends TaskState {
  @override
  List<Object?> get props => [];
}

// Taks loaded in progress
class TasksLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

// Tasks loaded
class TasksLoaded extends TaskState {

  TasksLoaded(this.tasksList);
  final List<TaskModel> tasksList;

  @override
  List<Object?> get props => [];
}

// Tasks deleted
class TaskDeleted extends TaskState {

  TaskDeleted(this.task);
  final TaskModel task;

  @override
  List<Object?> get props => [];
}

// Tasks deleted
class TasksUpdated extends TaskState {
  TasksUpdated();

  @override
  List<Object?> get props => [];
}

class TasksError extends TaskState {

  TasksError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
