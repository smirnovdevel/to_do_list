import 'package:sqflite/sqflite.dart';
import '../../config/common/app_db.dart';
import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';

final Logging log = Logging('DBProvider');

class DBProvider {
  DBProvider(this._database);
  Database? _database;

  Future<Database> database() async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  void _createDB(Database db, int version) {
    db.execute(AppDB.tableTodos);
  }

  /// initialize the database
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final String pathDB = '$dbPath/${AppDB.nameDB}';
    const int version = AppDB.version;
    log.info('Init DB $pathDB');
    return await openDatabase(pathDB, version: version, onCreate: _createDB);
  }

  /// GET ALL TODOS
  ///
  Future<List<Todo>> getTodos() async {
    log.info('Get todos ...');
    final db = await database();
    final List<Map<String, dynamic>> todosMapList =
        await db.query(AppDB.nameTodoTable);
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

  /// GET Todo
  ///
  Future<Todo?> getTodo({required String uuid}) async {
    log.info('Get todo uuid $uuid ...');
    final db = await database();
    Todo? task;
    final List<Map<String, dynamic>> todosMapList = await db.query(
      AppDB.nameTodoTable,
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    if (todosMapList.isNotEmpty) {
      task = Todo.fromMap(todosMapList.first);
      log.info('Get todo ok');
    } else {
      log.info('Get todo not found');
    }
    return task;
  }

  /// GET DELETED TODOS
  ///
  Future<List<Todo>> getDeletedTodos() async {
    log.info('Get Deleted Todos ...');
    final db = await database();
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
  Future<Todo?> saveTodo({required Todo todo}) async {
    log.info('Insert todo uuid: ${todo.uuid} ...');
    Todo? task;
    final db = await database();
    final List<Map<String, dynamic>> todosMapList = await db.query(
      AppDB.nameTodoTable,
      where: 'uuid = ?',
      whereArgs: [todo.uuid],
    );
    if (todosMapList.isEmpty) {
      // запись не найдена, добавляем
      try {
        await db.insert(AppDB.nameTodoTable, todo.toMap());
        task ??= todo;
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
        task ??= todo;
        log.info('Update todo uuid: ${todo.uuid}');
      } catch (e) {
        log.warning('Update todo uuid: ${todo.uuid} $e');
      }
    }
    return task;
  }

  /// UPDATE TODOS
  ///
  Future<void> updateTodos({required List<Todo> todos}) async {
    log.info('Update ${todos.length} todos ...');
    final db = await database();
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
  Future<Todo?> updateTodo({required Todo todo}) async {
    log.info('Update todo uuid: ${todo.uuid} ...');
    final db = await database();
    Todo? task;
    try {
      await db.update(
        AppDB.nameTodoTable,
        todo.toMap(),
        where: 'uuid = ?',
        whereArgs: [todo.uuid],
      );
      task ??= todo;
      log.info('Update todo uuid: ${todo.uuid}');
    } catch (e) {
      log.warning('Update todo uuid: ${todo.uuid} $e');
    }
    return task;
  }

  /// DELETE Todo
  ///
  Future<bool> deleteTodo({required Todo todo}) async {
    log.info('Delete todo uuid: ${todo.uuid} ...');
    final db = await database();
    try {
      await db.delete(
        AppDB.nameTodoTable,
        where: 'uuid = ?',
        whereArgs: [todo.uuid],
      );
      log.info('Delete todo uuid: ${todo.uuid}');
      return true;
    } catch (e) {
      log.warning('Delete todo uuid: ${todo.uuid} $e');
    }
    return false;
  }
}
