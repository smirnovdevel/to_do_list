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
  final List<TaskModel> tasksList;

  TasksLoaded(this.tasksList);

  @override
  List<Object?> get props => [];
}

class TasksError extends TaskState {
  final String message;

  TasksError({required this.message});

  @override
  List<Object?> get props => [message];
}
