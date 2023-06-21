import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../config/common/app_db.dart';
import '../../domain/models/todo.dart';

final Logger log = Logger('DBProvider');

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static late Database _database;

  Future<Database> get database async {
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String pathDB = '${appDirectory.path}/${AppDB.nameDB}';
    log.info('Init DB $pathDB');
    return await openDatabase(pathDB,
        version: AppDB.newVersion, onCreate: _createDB);
  }

  void _createDB(Database db, int version) {
    db.execute(AppDB.tableTasks);
  }

  void _upgradeDB(Database db, int oldVersion, int newVersion) {
    // int newVersion = AppDB.newVersion;
    if (oldVersion < newVersion) {
      log.info('upgrade DB from $oldVersion to $newVersion version');
      db.update(AppDB.tableTasks, AppDB.addRow);
    }
  }

  // GET ALL Tasks
  Future<List<Todo>> getTasks() async {
    log.info('Get todos ...');
    final Database db = await database;
    final List<Map<String, dynamic>> tasksMapList =
        await db.query(AppDB.nameTaskTable);
    final List<Todo> tasksList = [];
    for (final Map<String, dynamic> taskMap in tasksMapList) {
      tasksList.add(Todo.fromMap(taskMap));
    }
    tasksList.sort((Todo a, Todo b) {
      return a.created.compareTo(b.created);
    });
    log.info('Get ${tasksList.length} tasks');
    return tasksList;
  }

  // SAVE Task
  Future<Todo> saveTask({required Todo todo}) async {
    log.info('Insert task uuid: ${todo.uuid} ...');
    final Database db = await database;
    final List<Map<String, dynamic>> tasksMapList = await db.query(
      AppDB.nameTaskTable,
      where: 'uuid = ?',
      whereArgs: [todo.uuid],
    );
    if (tasksMapList.isEmpty) {
      try {
        await db.insert(AppDB.nameTaskTable, todo.toMap());
        log.info('Insert todo uuid: ${todo.uuid}');
      } catch (e) {
        log.warning('Insert todo uuid: ${todo.uuid} $e');
      }
    } else {
      log.info('Todo uuid: ${todo.uuid} found, update ...');
      try {
        await db.update(
          AppDB.nameTaskTable,
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

  // UPDATE Task
  Future<void> updateTask({required Todo task}) async {
    log.info('Update todo uuid: ${task.uuid} ...');
    final Database db = await database;
    try {
      await db.update(
        AppDB.nameTaskTable,
        task.toMap(),
        where: 'uuid = ?',
        whereArgs: [task.uuid],
      );
      log.info('Update todo uuid: ${task.uuid}');
    } catch (e) {
      log.warning('Update todo uuid: ${task.uuid} $e');
    }
  }

  // DELETE Task
  Future<int?> deleteTask({required Todo todo}) async {
    log.info('Delete todo uuid: ${todo.uuid} ...');
    final Database db = await database;
    try {
      final int resault = await db.delete(
        AppDB.nameTaskTable,
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
