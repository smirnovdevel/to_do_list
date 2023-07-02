import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../config/common/app_db.dart';
import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';

final Logging log = Logging('DBProvider');

class DBProvider {
  Database? _database;

  Future<Database> get _databaseGetter async {
    if (_database == null) {
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String pathDB = '${appDirectory.path}/${AppDB.nameDB}';
      log.info('Init DB $pathDB');
      _database = await openDatabase(pathDB,
          version: AppDB.version, onCreate: _createDB);
    }
    return _database!;
  }

  void _createDB(Database db, int version) {
    db.execute(AppDB.tableTodos);
  }

  /// GET ALL TODOS
  ///
  Future<List<Todo>> getTodos() async {
    log.info('Get todos ...');
    final db = await _databaseGetter;
    final List<Map<String, dynamic>> todosMapList = await db.query(
      AppDB.nameTodoTable,
      where: 'deleted = ?',
      whereArgs: [0],
    );
    final List<Todo> todosList = [];
    for (final Map<String, dynamic> todoMap in todosMapList) {
      todosList.add(Todo.fromMap(todoMap));
    }
    todosList.sort((Todo a, Todo b) {
      return a.created.compareTo(b.created);
    });
    log.info('Get ${todosList.length} todos');
    return todosList;
  }

  /// GET DELETED TODOS
  ///
  Future<List<Todo>> getDeletedTodos() async {
    log.info('Get Deleted Todos ...');
    final db = await _databaseGetter;
    final List<Map<String, dynamic>> todosMapList = await db.query(
      AppDB.nameTodoTable,
      where: 'deleted = ?',
      whereArgs: [1],
    );
    final List<Todo> todosList = [];
    if (todosMapList.isEmpty) {
      log.info('Get deleted todos not found');
      return todosList;
    }
    for (final Map<String, dynamic> todoMap in todosMapList) {
      todosList.add(Todo.fromMap(todoMap));
    }
    log.info('Get ${todosList.length} deleted todos');
    return todosList;
  }

  /// SAVE
  ///
  Future<Todo> saveTodo({required Todo todo}) async {
    log.info('Insert todo uuid: ${todo.uuid} ...');
    final db = await _databaseGetter;
    final List<Map<String, dynamic>> todosMapList = await db.query(
      AppDB.nameTodoTable,
      where: 'uuid = ?',
      whereArgs: [todo.uuid],
    );
    if (todosMapList.isEmpty) {
      // запись не найдена, добавляем
      try {
        await db.insert(AppDB.nameTodoTable, todo.toMap());
        log.info('Insert todo uuid: ${todo.uuid}');
      } catch (e) {
        log.warning('Insert todo uuid: ${todo.uuid} $e');
      }
    } else {
      // запись найдена, обновляем
      log.info('Todo uuid: ${todo.uuid} found, update ...');
      try {
        await db.update(
          AppDB.nameTodoTable,
          todo.toMap(),
          where: 'uuid = ?',
          whereArgs: [todo.uuid],
        );
        log.info('Update todo uuid: ${todo.uuid}');
      } catch (e) {
        log.warning('Update todo uuid: ${todo.uuid} $e');
      }
    }
    return todo;
  }

  /// UPDATE TODOS
  ///
  Future<void> updateTodos({required List<Todo> todos}) async {
    log.info('Update ${todos.length} todos ...');
    final db = await _databaseGetter;
    for (Todo task in todos) {
      /// test
      Todo todo = task.copyWith(upload: true);
      final List<Map<String, dynamic>> todosMapList = await db.query(
        AppDB.nameTodoTable,
        where: 'uuid = ?',
        whereArgs: [todo.uuid],
      );
      if (todosMapList.isEmpty) {
        // запись не найдена, добавляем
        try {
          await db.insert(AppDB.nameTodoTable, todo.toMap());
          log.info('Insert todo uuid: ${todo.uuid}');
        } catch (e) {
          log.warning('Insert todo uuid: ${todo.uuid} $e');
        }
      } else {
        await updateTodo(todo: todo);
      }
    }
  }

  /// UPDATE Todo
  ///
  Future<void> updateTodo({required Todo todo}) async {
    log.info('Update todo uuid: ${todo.uuid} ...');
    final db = await _databaseGetter;
    try {
      await db.update(
        AppDB.nameTodoTable,
        todo.toMap(),
        where: 'uuid = ?',
        whereArgs: [todo.uuid],
      );
      log.info('Update todo uuid: ${todo.uuid}');
    } catch (e) {
      log.warning('Update todo uuid: ${todo.uuid} $e');
    }
  }

  /// DELETE Todo
  ///
  Future<int?> deleteTodo({required Todo todo}) async {
    log.info('Delete todo uuid: ${todo.uuid} ...');
    final db = await _databaseGetter;
    try {
      final int resault = await db.delete(
        AppDB.nameTodoTable,
        where: 'uuid = ?',
        whereArgs: [todo.uuid],
      );
      log.info('Delete todo uuid: ${todo.uuid}');
      return resault;
    } catch (e) {
      log.warning('Delete todo uuid: ${todo.uuid} $e');
    }
    return null;
  }
}
