class AppDB {
  AppDB._();

  // Settings DB
  static const version = 1;
  static const nameDB = 'todo.db';

  // Table tasks
  static const nameTaskTable = 'tasks';
  static const tableTasks =
      'CREATE TABLE $nameTaskTable(id INTEGER PRIMARY KEY, title TEXT, active INTEGER, priority INTEGER,  unlimited INTEGER, deadline TEXT)';
}
