class AppDB {
  AppDB._();

  /// Settings DB
  static const version = 1;
  static const nameDB = 'todo.db';

  /// Table tasks
  static const nameTaskTable = 'tasks';
  static const tableTasks =
      'CREATE TABLE $nameTaskTable(id TEXT PRIMARY KEY, title TEXT, active INTEGER, priority INTEGER,  unlimited INTEGER, deadline TEXT, deleted INTEGER, created TEXT, changed TEXT, upload INTEGER, autor TEXT)';

  /// Settings for Upgrade DB
  static const newVersion = 1;
  static const addRow = {
    'delete': 0,
    'created': 'created',
    'changed': 'changed',
    'autor': 'autor',
  };
}
