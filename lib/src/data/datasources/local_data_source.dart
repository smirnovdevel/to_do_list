import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';
import '../db/database.dart';

final Logging log = Logging('LocalDataSource');

class TodoLocalDataSource {
  /// This service maybe change to Hive or any db sevice
  ///
  DBProvider sqflite = DBProvider();

  Future<List<Todo>> getTodos() async {
    log.info('Get Todos ...');
    final List<Todo> todosList = await sqflite.getTodos();
    log.info('Get ${todosList.length} todos');
    return Future.value(todosList);
  }

  Future<void> updateTodos({required List<Todo> todos}) async {
    log.info('Update ${todos.length} todos ...');
    await sqflite.updateTodos(todos: todos);
    log.info('Update todos');
  }

  Future<List<Todo>> getDeletedTodos() async {
    log.info('Get Deleted Todos ...');
    final List<Todo> todosList = await sqflite.getDeletedTodos();
    log.info('Get ${todosList.length} deleted todos');
    return Future.value(todosList);
  }

  Future<Todo> saveTodo({required Todo todo}) async {
    log.info('Save todo uuid: ${todo.uuid} ...');
    await sqflite.saveTodo(todo: todo);
    log.info('Save todo ok?');
    return todo;
  }

  Future<void> deleteTodo({required Todo todo}) async {
    log.info('Delete Todo uuid: ${todo.uuid} ...');
    await sqflite.deleteTodo(todo: todo);
    log.info('Delete Todo ok?');
  }
}
