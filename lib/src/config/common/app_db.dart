class AppDB {
  AppDB._();

  /// Settings DB
  static const int version = 1;
  static const String nameDB = 'todo.db';

  /// Table tasks
  static const String nameTaskTable = 'tasks';
  static const String tableTasks =
      'CREATE TABLE $nameTaskTable(id TEXT PRIMARY KEY, title TEXT, active INTEGER, priority INTEGER,  deadline TEXT, deleted INTEGER, created TEXT, changed TEXT, upload INTEGER, autor TEXT)';

  /// Settings for Upgrade DB
  static const int newVersion = 1;
  static const Map<String, Object> addRow = {
    'delete': 0,
    'created': 'created',
    'changed': 'changed',
    'autor': 'autor',
  };
}
