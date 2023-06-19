import '../../domain/models/task.dart';

abstract class ImplTaskDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> saveTask({required TaskModel task});
  Future<TaskModel> updateTask({required TaskModel task});
  Future<void> deleteTask({required TaskModel task});
}
