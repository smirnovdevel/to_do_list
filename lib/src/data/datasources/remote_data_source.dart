import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';
import '../web/dio_service.dart';

final Logging log = Logging('RemoteDataSource');

class TodoRemoteDataSource {
  /// This service maybe change to Dio or any web sevice
  ///
  // HttpService web = HttpService();
  DioService web = DioService();

  Future<List<Todo>> getTodos() async {
    log.info('Get Todos ...');
    final List<Todo> todosList = await web.getTodos();
    log.info('Get ${todosList.length} todos');
    return todosList;
  }

  Future<bool> updateTodos({required List<Todo> todos}) async {
    log.info('Update ${todos.length} todos ...');
    bool status = await web.updateTodos(todos: todos);
    log.info('Update todos');
    return status;
  }

  Future<Todo> saveTodo({required Todo todo}) async {
    log.info('Save todo uuid: ${todo.uuid} ...');
    final task = await web.saveTodo(todo: todo);
    return task;
  }

  Future<Todo> updateTodo({required Todo todo}) async {
    log.info('Save todo uuid: ${todo.uuid} ...');
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
