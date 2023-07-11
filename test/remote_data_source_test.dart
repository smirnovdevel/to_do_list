import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/domain/models/todo.dart';

import 'data/datasource/remote_data_source_mock.dart';
import 'data/todo_mock.dart';
import 'data/web/api_http_mock.dart';

main() async {
  ///
  /// Arrange
  ///
  RemoteDataSourceMock remoteDataSourceMock = RemoteDataSourceMock(HttpMock());
  Todo todo = TodoMock().get(title: 'Test todo').copyWith();

  ///
  /// Groups
  ///
  group('Remote data source:', () {
    test('Upload todo', () async {
      ///
      /// Act
      ///
      final Todo send = await remoteDataSourceMock.saveTodo(todo: todo);

      ///
      /// Assert
      ///
      expect(true, send.upload);
    });
    test('Save todo', () async {
      ///
      /// Assert
      ///
      final Todo? task = await remoteDataSourceMock.getTodo(uuid: todo.uuid);
      expect(false, task == null);
    });
    test('Update todo', () async {
      ///
      /// Act
      ///
      await remoteDataSourceMock.updateTodo(
          todo: todo.copyWith(title: 'Update title'));

      ///
      /// Assert
      ///
      final task = await remoteDataSourceMock.getTodo(uuid: todo.uuid);
      expect('Update title', task?.title);
    });
    test('Delete todo', () async {
      ///
      /// Act
      ///
      await remoteDataSourceMock.deleteTodo(todo: todo);

      ///
      /// Assert
      ///
      final Todo? task = await remoteDataSourceMock.getTodo(uuid: todo.uuid);
      expect(null, task);
    });
  });
}
