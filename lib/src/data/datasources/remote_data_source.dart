import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';
import '../web/http_service.dart';

final Logging log = Logging('RemoteDataSource');

class RemoteDataSource {
  RemoteDataSource(this.web);
  final HttpService web;

  Future<List<Todo>> getTodos() async {
    log.info('Get todos ...');
    final List<Todo> todosList = await web.getTodos();
    log.info('Get ${todosList.length} todos');
    return todosList;
  }

  Future<Todo?> getTodo({required String uuid}) async {
    log.info('Get todo uuid: $uuid ...');
    final Todo? todo = await web.getTodo(uuid: uuid);
    log.info('Get todo ${todo == null ? 'not found' : ''}');
    return todo;
  }

  Future<bool> updateTodos({required List<Todo> todos}) async {
    log.info('Update ${todos.length} todos ...');
    bool result = await web.updateTodos(todos: todos);
    log.info('Update todos');
    return result;
  }

  Future<Todo> saveTodo({required Todo todo}) async {
    log.info('Save todo uuid: ${todo.uuid} ...');
    final task = await web.saveTodo(todo: todo);
    return task;
  }

  Future<Todo> updateTodo({required Todo todo}) async {
    log.info('Update todo uuid: ${todo.uuid} ...');
    final task = await web.updateTodo(todo: todo);
    return task;
  }

  Future<bool> deleteTodo({required Todo todo}) async {
    log.info('Delete todo uuid: ${todo.uuid} ...');
    final deleted = await web.deleteTodo(todo: todo);
    log.info('Delete todo');
    return deleted;
  }
}
