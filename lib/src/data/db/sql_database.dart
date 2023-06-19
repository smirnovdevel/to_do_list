import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../config/common/app_db.dart';
import '../../domain/models/task.dart';

final Logger log = Logger('SQL DBProvider');

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static late Database _database;

  /// Sample record
  /// id:137454, title:'Купить что-то', active:1, priority:2, unlimited:0, deadline:'2022-05-30T12:00:00Z'

  Future<Database> get database async {
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String pathDB = '${appDirectory.path}/${AppDB.nameDB}';
    log.info('init DB $pathDB');
    return await openDatabase(pathDB,
        version: AppDB.newVersion, onCreate: _createDB, onUpgrade: _upgradeDB);
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
  Future<List<TaskModel>> getTasks() async {
    log.info('get tasks ...');
    final Database db = await database;
    final List<Map<String, dynamic>> tasksMapList =
        await db.query(AppDB.nameTaskTable);
    final List<TaskModel> tasksList = [];
    for (final Map<String, dynamic> taskMap in tasksMapList) {
      tasksList.add(TaskModel.fromMap(taskMap));
    }
    tasksList.sort((TaskModel a, TaskModel b) {
      return a.created.compareTo(b.created);
    });
    log.info('get ${tasksList.length} tasks');
    return tasksList;
  }

  // SAVE Task
  Future<TaskModel> saveTask({required TaskModel task}) async {
    log.info('insert task id: ${task.uuid} ...');
    final Database db = await database;
    final List<Map<String, dynamic>> tasksMapList = await db.query(
      AppDB.nameTaskTable,
      where: 'id = ?',
      whereArgs: [task.uuid],
    );
    if (tasksMapList.isEmpty) {
      try {
        await db.insert(AppDB.nameTaskTable, task.toMap());
        log.info('insert task id: ${task.uuid}');
      } catch (e) {
        log.warning('insert task id: ${task.uuid} $e');
      }
    } else {
      log.info('task id: ${task.uuid} found, update ...');
      try {
        await db.update(
          AppDB.nameTaskTable,
          task.toMap(),
          where: 'id = ?',
          whereArgs: [task.uuid],
        );
        log.info('update task id: ${task.uuid}');
      } catch (e) {
        log.warning('update task id: ${task.uuid} $e');
      }
    }
    return task;
  }

  // UPDATE Task
  Future<void> updateTask({required TaskModel task}) async {
    log.info('update task id: ${task.uuid} ...');
    final Database db = await database;
    try {
      await db.update(
        AppDB.nameTaskTable,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.uuid],
      );
      log.info('update task id: ${task.uuid}');
    } catch (e) {
      log.warning('update task id: ${task.uuid} $e');
    }
  }

  // DELETE Task
  Future<int?> deleteTask({required TaskModel task}) async {
    log.info('delete task uuid: ${task.uuid} ...');
    final Database db = await database;
    try {
      final int resault = await db.delete(
        AppDB.nameTaskTable,
        where: 'id = ?',
        whereArgs: [task.uuid],
      );
      log.info('delete task uuid: ${task.uuid}');
      return resault;
    } catch (e) {
      log.warning('delete task uuid: ${task.uuid} $e');
    }
    return null;
  }
}
