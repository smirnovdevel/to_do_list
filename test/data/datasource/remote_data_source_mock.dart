import 'package:to_do_list/src/domain/models/todo.dart';
import 'package:to_do_list/src/utils/core/logging.dart';

import '../web/api_http_mock.dart';

final Logging log = Logging('RemoteDataSource');

class RemoteDataSourceMock {
  RemoteDataSourceMock(this.web);
  final HttpMock web;

  Future<List<Todo>> getTodos() async {
    log.debug('Get todos ...');
    final List<Todo> todosList = await web.getTodos();
    log.debug('Get ${todosList.length} todos');
    return todosList;
  }

  Future<Todo?> getTodo({required String uuid}) async {
    log.debug('Get todo uuid: $uuid ...');
    final Todo? todo = await web.getTodo(uuid: uuid);
    log.debug('Get todo ${todo == null ? 'not found' : ''}');
    return todo;
  }

  Future<bool> updateTodos({required List<Todo> todos}) async {
    log.debug('Update ${todos.length} todos ...');
    bool result = await web.updateTodos(todos: todos);
    log.debug('Update todos');
    return result;
  }

  Future<Todo> saveTodo({required Todo todo}) async {
    log.debug('Save todo uuid: ${todo.uuid} ...');
    final task = await web.saveTodo(todo: todo);
    return task;
  }

  Future<Todo> updateTodo({required Todo todo}) async {
    log.debug('Update todo uuid: ${todo.uuid} ...');
    final task = await web.updateTodo(todo: todo);
    return task;
  }

  Future<bool> deleteTodo({required Todo todo}) async {
    log.debug('Delete todo uuid: ${todo.uuid} ...');
    final deleted = await web.deleteTodo(todo: todo);
    log.debug('Delete todo');
    return deleted;
  }
}
