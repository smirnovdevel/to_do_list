import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../config/common/app_db.dart';
import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';

final Logging log = Logging('DBProvider');

class DBProvider {
  DBProvider({required this.isTest});
  bool isTest = false;
  Database? _database;

  Future<Database> database() async {
    if (_database != null) return _database!;
    if (isTest) {
      _database = await _initTestDB();
    } else {
      _database = await _initDB();
    }

    return _database!;
  }

  void _createDB(Database db, int version) {
    db.execute(AppDB.tableTodos);
  }

  /// initialize test the database
  Future<Database> _initTestDB() async {
    return await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        onCreate: (db, version) async {
          await db.execute(AppDB.tableTodos);
        },
        version: AppDB.version,
      ),
    );
  }

  /// initialize the database
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final String pathDB = '$dbPath/${AppDB.nameDB}';
    const int version = AppDB.version;
    log.debug('Init DB $pathDB');
    return await openDatabase(pathDB, version: version, onCreate: _createDB);
  }

  /// GET ALL TODOS
  ///
  Future<List<Todo>> getTodos() async {
    log.debug('Get todos ...');
    final db = await database();
    final List<Map<String, dynamic>> maps = await db.query(AppDB.nameTodoTable);
    final List<Todo> todos = [];
    for (var map in maps) {
      todos.add(Todo.fromJson(map));
    }

    todos.sort((Todo a, Todo b) {
      return a.created!.compareTo(b.created!);
    });
    log.debug('Get ${todos.length} todos');
    return todos;
  }

  /// GET Todo
  ///
  Future<Todo?> getTodo({required String uuid}) async {
    log.debug('Get todo uuid $uuid ...');
    final db = await database();
    Todo? task;
    final List<Map<String, dynamic>> maps = await db.query(
      AppDB.nameTodoTable,
      where: 'id = ?',
      whereArgs: [uuid],
    );
    if (maps.isNotEmpty) {
      task = Todo.fromJson(maps.first);
      log.debug('Get todo ok');
    } else {
      log.debug('Get todo not found');
    }
    return task;
  }

  /// GET DELETED TODOS
  ///
  Future<List<Todo>> getDeletedTodos() async {
    log.debug('Get Deleted Todos ...');
    final db = await database();
    final List<Map<String, dynamic>> maps = await db.query(
      AppDB.nameTodoTable,
      where: 'deleted = ?',
      whereArgs: [1],
    );
    final List<Todo> todos = [];
    if (maps.isEmpty) {
      log.debug('Get deleted todos not found');
      return todos;
    }
    for (var map in maps) {
      todos.add(Todo.fromJson(map));
    }
    log.debug('Get ${todos.length} deleted todos');
    return todos;
  }

  /// SAVE
  ///
  Future<Todo?> saveTodo({required Todo todo}) async {
    log.debug('Insert todo uuid: ${todo.uuid} ...');
    Todo? task;
    final db = await database();
    final List<Map<String, dynamic>> maps = await db.query(
      AppDB.nameTodoTable,
      where: 'id = ?',
      whereArgs: [todo.uuid],
    );
    if (maps.isEmpty) {
      // запись не найдена, добавляем
      try {
        await db.insert(AppDB.nameTodoTable, todo.toDB());
        task ??= todo;
        log.debug('Insert todo uuid: ${todo.uuid}');
      } catch (e) {
        log.warning('Insert todo uuid: ${todo.uuid} $e');
      }
    } else {
      // запись найдена, обновляем
      log.debug('Todo uuid: ${todo.uuid} found, update ...');
      try {
        await db.update(
          AppDB.nameTodoTable,
          todo.toDB(),
          where: 'id = ?',
          whereArgs: [todo.uuid],
        );
        task ??= todo;
        log.debug('Update todo uuid: ${todo.uuid}');
      } catch (e) {
        log.warning('Update todo uuid: ${todo.uuid} $e');
      }
    }
    return task;
  }

  /// UPDATE TODOS
  ///
  Future<void> updateTodos({required List<Todo> todos}) async {
    log.debug('Update ${todos.length} todos ...');
    final db = await database();
    for (Todo task in todos) {
      /// test
      Todo todo = task.copyWith(upload: true);
      final List<Map<String, dynamic>> maps = await db.query(
        AppDB.nameTodoTable,
        where: 'id = ?',
        whereArgs: [todo.uuid],
      );
      if (maps.isEmpty) {
        // запись не найдена, добавляем
        try {
          await db.insert(AppDB.nameTodoTable, todo.toDB());
          log.debug('Insert todo uuid: ${todo.uuid}');
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
    log.debug('Update todo uuid: ${todo.uuid} ...');
    final db = await database();
    Todo? task;
    try {
      await db.update(
        AppDB.nameTodoTable,
        todo.toDB(),
        where: 'id = ?',
        whereArgs: [todo.uuid],
      );
      task ??= todo;
      log.debug('Update todo uuid: ${todo.uuid}');
    } catch (e) {
      log.warning('Update todo uuid: ${todo.uuid} $e');
    }
    return task;
  }

  /// DELETE Todo
  ///
  Future<bool> deleteTodo({required Todo todo}) async {
    log.debug('Delete todo uuid: ${todo.uuid} ...');
    final db = await database();
    try {
      await db.delete(
        AppDB.nameTodoTable,
        where: 'id = ?',
        whereArgs: [todo.uuid],
      );
      log.debug('Delete todo uuid: ${todo.uuid}');
      return true;
    } catch (e) {
      log.warning('Delete todo uuid: ${todo.uuid} $e');
    }
    return false;
  }
}
