class AppDB {
  AppDB._();

  /// Settings DB
  static const int version = 1;
  static const String nameDB = 'todo.db';

  /// Table todos
  static const String nameTodoTable = 'todos';
  static const String tableTodos =
      'CREATE TABLE $nameTodoTable(uuid TEXT PRIMARY KEY, title TEXT, done INTEGER, priority INTEGER,  deadline TEXT, deleted INTEGER, created TEXT, changed TEXT, upload INTEGER, autor TEXT)';
}
