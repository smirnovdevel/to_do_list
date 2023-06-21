import '../../domain/models/todo.dart';

abstract class TodoDataSource {
  Future<List<Todo>> getTasks();
  Future<Todo> saveTask({required Todo todo});
  Future<Todo> updateTask({required Todo todo});
  Future<void> deleteTask({required Todo todo});
}
