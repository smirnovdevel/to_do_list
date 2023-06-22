import '../../domain/models/todo.dart';

abstract class IWebService {
  Future<List<Todo>> getTodos();
  Future<Todo> saveTodo({required Todo todo});
  Future<Todo> deleteTodo({required Todo todo});
}
