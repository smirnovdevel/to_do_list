import 'package:logging/logging.dart';

import '../../domain/models/todo.dart';
import 'data_source.dart';
import '../db/database.dart';

final Logger log = Logger('LocalDataSource');

class ITodoLocalDataSource implements TodoDataSource {
  @override
  Future<List<Todo>> getTodos() async {
    log.info('Get Todos ...');
    final List<Todo> todosList = await DBProvider.db.getTodos();
    log.info('Get ${todosList.length} todos');
    return Future.value(todosList);
  }

  @override
  Future<Todo> saveTodo({required Todo todo}) async {
    log.info('Save todo uuid: ${todo.uuid} ...');
    await DBProvider.db.saveTodo(todo: todo);
    log.info('Save todo ok?');
    return todo;
  }

  @override
  Future<Todo> updateTodo({required Todo todo}) async {
    log.info('Update Todo uuid: ${todo.uuid} ...');
    await DBProvider.db.saveTodo(todo: todo);
    log.info('Update Todo ok?');
    return todo;
  }

  @override
  Future<void> deleteTodo({required Todo todo}) async {
    log.info('Delete Todo uuid: ${todo.uuid} ...');
    await DBProvider.db.deleteTodo(todo: todo);
    log.info('Delete Todo ok?');
  }
}
