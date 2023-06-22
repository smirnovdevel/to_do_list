import 'package:logging/logging.dart';

import '../../domain/models/todo.dart';
import '../web/http_service.dart';

final Logger log = Logger('RemoteDataSource');

class TodoRemoteDataSource {
  /// This service maybe change to Dio or any web sevice
  ///
  HttpService web = HttpService();

  Future<List<Todo>> getTodos() async {
    log.info('Get Todos ...');
    final List<Todo> todosList = await web.getTodos();
    log.info('Get ${todosList.length} todos');
    return todosList;
  }

  Future<Todo> saveTodo({required Todo todo}) async {
    log.info('Save todo uuid: ${todo.uuid} ...');
    final task = await web.saveTodo(todo: todo);
    return task;
  }

  Future<void> deleteTodo({required Todo todo}) async {
    log.info('Delete todo uuid: ${todo.uuid} ...');
    await web.deleteTodo(todo: todo);
    log.info('Delete todo');
  }
}
