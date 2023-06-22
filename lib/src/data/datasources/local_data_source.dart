import 'package:logging/logging.dart';

import '../../domain/models/todo.dart';
import '../db/database.dart';

final Logger log = Logger('LocalDataSource');

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

  Future<Todo> saveTodo({required Todo todo}) async {
    log.info('Save todo uuid: ${todo.uuid} ...');
    await sqflite.saveTodo(todo: todo);
    log.info('Save todo ok?');
    return todo;
  }

  void deleteTodo({required Todo todo}) {
    log.info('Delete Todo uuid: ${todo.uuid} ...');
    sqflite.deleteTodo(todo: todo);
    log.info('Delete Todo ok?');
  }
}
