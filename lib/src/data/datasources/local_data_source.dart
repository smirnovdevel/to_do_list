import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';
import '../db/database.dart';
import 'data_source.dart';

final Logging log = Logging('LocalDataSource');

class LocalDataSource implements IDataSource {
  LocalDataSource(this.db);
  final DBProvider db;

  /// This service maybe change to Hive or any db sevice
  ///

  @override
  Future<List<Todo>> getTodos() async {
    log.debug('Get Todos ...');
    final List<Todo> todosList = await db.getTodos();
    log.debug('Get ${todosList.length} todos');
    return Future.value(todosList);
  }

  @override
  Future<Todo?> getTodo({required String uuid}) async {
    log.debug('Get Todo uuid: $uuid ...');
    final Todo? todo = await db.getTodo(uuid: uuid);
    log.debug('Get todo ${todo == null ? 'not found' : 'ok'}');
    return todo;
  }

  @override
  Future<bool> updateTodos({required List<Todo> todos}) async {
    log.debug('Update ${todos.length} todos ...');
    await db.updateTodos(todos: todos);
    log.debug('Update todos');
    return true;
  }

  @override
  Future<Todo?> updateTodo({required Todo todo}) async {
    log.debug('Update todo uuid: ${todo.uuid} ...');
    final Todo? task = await db.updateTodo(todo: todo);
    log.debug('Update todos');
    return task;
  }

  Future<List<Todo>> getDeletedTodos() async {
    log.debug('Get Deleted Todos ...');
    final List<Todo> todosList = await db.getDeletedTodos();
    log.debug('Get ${todosList.length} deleted todos');
    return Future.value(todosList);
  }

  @override
  Future<Todo?> saveTodo({required Todo todo}) async {
    log.debug('Save todo uuid: ${todo.uuid} ...');
    final task = await db.saveTodo(todo: todo);
    log.debug('Save todo ok?');
    return task;
  }

  @override
  Future<bool> deleteTodo({required Todo todo}) async {
    log.debug('Delete Todo uuid: ${todo.uuid} ...');
    final bool result = await db.deleteTodo(todo: todo);
    log.debug('Delete Todo ok?');
    return result;
  }
}
