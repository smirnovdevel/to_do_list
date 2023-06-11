import 'dart:io';

import 'dart:developer' as console;

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/common/app_db.dart';
import 'package:to_do_list/models/task.dart';

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
    console.log(
        '\u001b[1;33m Task database: \u001b[1;34m _initDB \u001b[0m path \u001b[1;32m $path');
    return await openDatabase(path,
        version: AppDB.version, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(AppDB.tableTasks);
  }

  // GET All Tasks
  Future<List<TaskModel>> getAllTasksFromDB() async {
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
    console.log(
        '\u001b[1;33m Task database: \u001b[1;34m getAllTasksFromDB \u001b[0m loaded \u001b[1;32m ${tasksList.length} \u001b[0m record from DB');
    return tasksList;
  }

  // INSERT Task
  Future<TaskModel> insertTask(TaskModel task) async {
    Database db = await database;
    final List<Map<String, dynamic>> tasksMapList = await db.query(
      AppDB.nameTaskTable,
      where: 'id = ?',
      whereArgs: [task.id],
    );
    if (tasksMapList.isEmpty) {
      task.id = await db.insert(AppDB.nameTaskTable, task.toMap());
    } else {
      updateSchedule(task);
    }
    return task;
  }

  // UPDATE Task
  Future<int> updateSchedule(TaskModel task) async {
    Database db = await database;
    return await db.update(
      AppDB.nameTaskTable,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // DELETE Task
  Future<int> deleteTask({required int id}) async {
    Database db = await database;
    console.log(
        '\u001b[1;33m Task database: \u001b[1;34m deleteTask \u001b[0m id: \u001b[1;32m $id');
    return await db.delete(
      AppDB.nameTaskTable,
      where: '$id = ?',
      whereArgs: [id],
    );
  }
}
