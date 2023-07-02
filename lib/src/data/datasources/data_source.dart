import '../../domain/models/todo.dart';

abstract class IDataSource {
  // получить список всех тасок
  Future<List<Todo>> getTodos();

  // получить одну таску по uuid
  Future<Todo?> getTodo({required String uuid});

  // обновить данные всех тасок из списка
  Future<bool> updateTodos({required List<Todo> todos});

  // сохранить таску
  Future<Todo?> saveTodo({required Todo todo});

  // обновить данные одной таски по uuid
  Future<Todo?> updateTodo({required Todo todo});

  // удалить таску с таким uuid
  Future<bool> deleteTodo({required Todo todo});
}
