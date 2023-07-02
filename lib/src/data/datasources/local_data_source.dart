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
    log.info('Get Todos ...');
    final List<Todo> todosList = await db.getTodos();
    log.info('Get ${todosList.length} todos');
    return Future.value(todosList);
  }

  @override
  Future<Todo?> getTodo({required String uuid}) async {
    log.info('Get Todo uuid: $uuid ...');
    final Todo? todo = await db.getTodo(uuid: uuid);
    log.info('Get todo ${todo == null ? 'not found' : 'ok'}');
    return todo;
  }

  @override
  Future<bool> updateTodos({required List<Todo> todos}) async {
    log.info('Update ${todos.length} todos ...');
    await db.updateTodos(todos: todos);
    log.info('Update todos');
    return true;
  }

  @override
  Future<Todo?> updateTodo({required Todo todo}) async {
    log.info('Update todo uuid: ${todo.uuid} ...');
    final Todo? task = await db.updateTodo(todo: todo);
    log.info('Update todos');
    return task;
  }

  Future<List<Todo>> getDeletedTodos() async {
    log.info('Get Deleted Todos ...');
    final List<Todo> todosList = await db.getDeletedTodos();
    log.info('Get ${todosList.length} deleted todos');
    return Future.value(todosList);
  }

  @override
  Future<Todo?> saveTodo({required Todo todo}) async {
    log.info('Save todo uuid: ${todo.uuid} ...');
    final task = await db.saveTodo(todo: todo);
    log.info('Save todo ok?');
    return task;
  }

  @override
  Future<bool> deleteTodo({required Todo todo}) async {
    log.info('Delete Todo uuid: ${todo.uuid} ...');
    final bool result = await db.deleteTodo(todo: todo);
    log.info('Delete Todo ok?');
    return result;
  }
}
