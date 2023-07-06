import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/domain/models/todo.dart';

import 'data/todo_mock.dart';

main() async {
  ///
  /// Arrange
  ///
  Todo todo = Todo.copyFrom(TodoMock().get(title: 'Test todo'));

  ///
  /// Groups
  ///
  test('Todo toJson / fromJson', () {
    ///
    /// Act
    ///
    Todo task = todo.copyWith(upload: true);
    final Map<String, dynamic> json = task.toJson();

    ///
    /// Assert
    ///
    expect(task, Todo.fromJson(json));
  });
}
