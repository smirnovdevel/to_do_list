import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/data/datasources/remote_data_source.dart';
import 'package:to_do_list/src/domain/models/todo.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();
DateTime dateTimeNow =
    DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);

main() async {
  ///
  /// Arrange
  ///
  RemoteDataSource remoteDataSource = RemoteDataSource();
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

  ///
  /// Groups
  ///
  group('Remote data source:', () {
    test('Upload todo', () async {
      ///
      /// Act
      ///
      final Todo send = await remoteDataSource.saveTodo(todo: todo);

      ///
      /// Assert
      ///
      expect(true, send.upload);
    });
    test('Save todo', () async {
      ///
      /// Assert
      ///
      final Todo? task = await remoteDataSource.getTodo(uuid: todo.uuid);
      expect(false, task == null);
    });
    test('Update todo', () async {
      ///
      /// Act
      ///
      await remoteDataSource.updateTodo(
          todo: todo.copyWith(title: 'Update title'));

      ///
      /// Assert
      ///
      final task = await remoteDataSource.getTodo(uuid: todo.uuid);
      expect('Update title', task?.title);
    });
    test('Delete todo', () async {
      ///
      /// Act
      ///
      await remoteDataSource.deleteTodo(todo: todo);

      ///
      /// Assert
      ///
      final Todo? task = await remoteDataSource.getTodo(uuid: todo.uuid);
      expect(null, task);
    });
  });
}
