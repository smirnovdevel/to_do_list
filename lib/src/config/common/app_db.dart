class AppDB {
  AppDB._();

  /// Settings DB
  static const int version = 1;
  static const String nameDB = 'todo.db';

  /// Table todos
  static const String nameTodoTable = 'todos';
  static const String tableTodos =
      'CREATE TABLE $nameTodoTable(id TEXT PRIMARY KEY, text TEXT, done INTEGER, importance TEXT,  deadline INTEGER, deleted INTEGER, created_at INTEGER, changed_at INTEGER, upload INTEGER, last_updated_by TEXT)';
}
