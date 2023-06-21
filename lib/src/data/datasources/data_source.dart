import '../../domain/models/todo.dart';

abstract class TodoDataSource {
  Future<List<Todo>> getTodos();
  Future<Todo> saveTodo({required Todo todo});
  Future<Todo> updateTodo({required Todo todo});
  Future<void> deleteTodo({required Todo todo});
}
