import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:to_do_list/src/data/datasources/local_data_source.dart';
import 'package:to_do_list/src/data/db/database.dart';
import 'package:to_do_list/src/domain/models/todo.dart';

import 'data/todo_mock.dart';

main() async {
  sqfliteFfiInit();

  ///
  /// Arrange
  ///
  DBProvider dbProvider = DBProvider(isTest: true);
  LocalDataSource localDataSource = LocalDataSource(dbProvider);
  Todo todo = TodoMock().get(title: 'Test todo').copyWith();

  ///
  /// Groups
  ///
  group('Local data source:', () {
    test('Get todos', () async {
      ///
      /// Act
      ///
      List<Todo> todos = await localDataSource.getTodos();
      for (Todo todo in todos) {
        await localDataSource.deleteTodo(todo: todo);
      }

      ///
      /// Assert
      ///
      todos = await localDataSource.getTodos();
      expect(0, todos.length);
    });

    test('Update todos', () async {
      ///
      /// Act
      ///
      Todo task = todo.copyWith(deleted: true);
      await localDataSource.updateTodos(todos: [task]);

      ///
      /// Assert
      ///
      List<Todo> todos = await localDataSource.getDeletedTodos();
      expect(todos.first, task);
    });

    test('Save todo', () async {
      ///
      /// Act
      ///
      await localDataSource.saveTodo(todo: todo);

      ///
      /// Assert
      ///
      final task = await localDataSource.getTodo(uuid: todo.uuid);
      expect(todo, task);
    });

    test('Update todo', () async {
      ///
      /// Act
      ///
      await localDataSource.updateTodo(
          todo: todo.copyWith(title: 'Update title'));

      ///
      /// Assert
      ///
      final task = await localDataSource.getTodo(uuid: todo.uuid);
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
      final Todo? task = await localDataSource.getTodo(uuid: todo.uuid);
      expect(null, task);
    });
  });
}
