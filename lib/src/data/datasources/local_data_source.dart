import 'package:logging/logging.dart';

import '../../domain/models/todo.dart';
import 'data_source.dart';
import '../db/database.dart';

final Logger log = Logger('LocalDataSource');

class ITodoLocalDataSource implements TodoDataSource {
  @override
  Future<List<Todo>> getTasks() async {
    log.info('Get Tasks ...');
    final List<Todo> tasksList = await DBProvider.db.getTasks();
    log.info('Get ${tasksList.length} tasks');
    return Future.value(tasksList);
  }

  @override
  Future<Todo> saveTask({required Todo todo}) async {
    log.info('Save task uuid: ${todo.uuid} ...');
    await DBProvider.db.saveTask(todo: todo);
    log.info('Save task ok?');
    return todo;
  }

  @override
  Future<Todo> updateTask({required Todo todo}) async {
    log.info('Update Task uuid: ${todo.uuid} ...');
    await DBProvider.db.saveTask(todo: todo);
    log.info('Update Task ok?');
    return todo;
  }

  @override
  Future<void> deleteTask({required Todo todo}) async {
    log.info('Delete Todo uuid: ${todo.uuid} ...');
    await DBProvider.db.deleteTask(todo: todo);
    log.info('Delete Todo ok?');
  }
}
