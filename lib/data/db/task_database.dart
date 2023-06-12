import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/common/app_db.dart';
import 'package:to_do_list/models/task.dart';

import '../../core/logging.dart';

final log = logger(DBProvider);

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
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/${AppDB.nameDB}';
    log.d('init DB $path');
    return await openDatabase(path,
        version: AppDB.version, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(AppDB.tableTasks);
  }

  // GET All Tasks
  Future<List<TaskModel>> getAllTasksFromDB() async {
    log.i('get tasks ...');
    Database db = await database;
    final List<Map<String, dynamic>> tasksMapList =
        await db.query(AppDB.nameTaskTable);
    final List<TaskModel> tasksList = [];
    for (var taskMap in tasksMapList) {
      tasksList.add(TaskModel.fromMap(taskMap));
    }
    tasksList.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    log.d('get ${tasksList.length} tasks');
    return tasksList;
  }

  // INSERT Task
  Future<TaskModel> insertTask(TaskModel task) async {
    log.i('insert task id: ${task.id} ...');
    Database db = await database;
    final List<Map<String, dynamic>> tasksMapList = await db.query(
      AppDB.nameTaskTable,
      where: 'id = ?',
      whereArgs: [task.id],
    );
    if (tasksMapList.isEmpty) {
      try {
        await db.insert(AppDB.nameTaskTable, task.toMap());
        log.d('insert task id: ${task.id}');
      } catch (e) {
        log.e('insert task id: ${task.id} ${e.toString()}');
      }
    } else {
      log.i('task id: ${task.id} found, update ...');
      try {
        await db.update(
          AppDB.nameTaskTable,
          task.toMap(),
          where: 'id = ?',
          whereArgs: [task.id],
        );
        log.d('update task id: ${task.id}');
      } catch (e) {
        log.e('update task id: ${task.id} ${e.toString()}');
      }
    }
    return task;
  }

  // UPDATE Task
  Future<void> updateTask({required TaskModel task}) async {
    log.i('update task id: ${task.id} ...');
    Database db = await database;
    try {
      await db.update(
        AppDB.nameTaskTable,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      log.d('update task id: ${task.id}');
    } catch (e) {
      log.e('update task id: ${task.id} ${e.toString()}');
    }
  }

  // DELETE Task
  Future<void> deleteTask({required int id}) async {
    log.i('delete task id: $id ...');
    Database db = await database;
    try {
      await db.delete(
        AppDB.nameTaskTable,
        where: '$id = ?',
        whereArgs: [id],
      );
      log.d('delete task id: $id');
    } catch (e) {
      log.e('delete task id: $id ${e.toString()}');
    }
  }
}
