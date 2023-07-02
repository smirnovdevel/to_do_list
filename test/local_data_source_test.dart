import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:to_do_list/src/config/common/app_db.dart';
import 'package:to_do_list/src/data/datasources/local_data_source.dart';
import 'package:to_do_list/src/data/db/database.dart';
import 'package:to_do_list/src/domain/models/todo.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();
DateTime dateTimeNow =
    DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
Todo todo = Todo(
    uuid: uuid.v1(),
    title: 'Test todo',
    done: false,
    priority: 0,
    deadline: dateTimeNow,
    deleted: false,
    created: dateTimeNow,
    changed: dateTimeNow,
    upload: false,
    autor: 'Test');

main() async {
  sqfliteFfiInit();

  ///
  /// Arrange
  ///
  Database database = await databaseFactoryFfi.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(
      onCreate: (db, version) async {
        await db.execute(AppDB.tableTodos);
      },
      version: AppDB.version,
    ),
  );

  LocalDataSource localDataSource = LocalDataSource(DBProvider(database));

  ///
  /// Groups
  ///
  group('Local data source:', () {
    test('Save todo', () async {
      ///
      /// Act
      ///
      await localDataSource.saveTodo(todo: todo);

      ///
      /// Assert
      ///
      final task = await localDataSource.getTodo(uuid: todo.uuid!);
      expect(todo, task);
    });

    test('Update todo', () async {
      ///
      /// Act
      ///
      await localDataSource.saveTodo(
          todo: todo.copyWith(title: 'Update title'));

      ///
      /// Assert
      ///
      final task = await localDataSource.getTodo(uuid: todo.uuid!);
      expect('Update title', task?.title);
    });
    test('Delete todo', () async {
      ///
      /// Act
      ///
      await localDataSource.deleteTodo(todo: todo);

      ///
      /// Assert
      ///
      final Todo? task = await localDataSource.getTodo(uuid: todo.uuid!);
      expect(null, task);
    });
  });
}
