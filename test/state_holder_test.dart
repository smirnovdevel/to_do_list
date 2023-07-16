import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/domain/models/todo.dart';
import 'package:to_do_list/src/presentation/providers/todos_provider.dart';
import 'package:uuid/uuid.dart';

int unixTimeStamp = DateTime.now().toLocal().millisecondsSinceEpoch;

main() {
  ///
  /// Arrange
  ///
  TodosStateHolder todosStateHolder = TodosStateHolder();
  Todo todo = Todo(
      // ignore: prefer_const_constructors
      uuid: Uuid().v1(),
      title: 'Test todo',
      done: false,
      deadline: unixTimeStamp,
      created: unixTimeStamp,
      changed: unixTimeStamp,
      deviceId: 'Test');

  ///
  /// Groups
  ///
  group('Todos state holder:', () {
    test('Adding todo', () {
      ///
      /// Act
      ///
      todosStateHolder.addTodo(todo: todo);
      var state = todosStateHolder.debugState;

      ///
      /// Assert
      ///
      expect(todo, state?.last);
    });
    test('Update todo', () {
      ///
      /// Act
      ///
      todosStateHolder.addTodo(todo: todo);
      todosStateHolder.updateTodo(todo: todo.copyWith(title: 'Update title'));
      var state = todosStateHolder.debugState;

      ///
      /// Assert
      ///
      expect('Update title',
          state?.firstWhere((item) => item.uuid == todo.uuid).title);
    });
    test('Delete todo', () {
      ///
      /// Act
      ///
      todosStateHolder.addTodo(todo: todo);
      todosStateHolder.deleteTodo(todo: todo);
      var state = todosStateHolder.debugState;

      ///
      /// Assert
      ///
      expect(true, state?.isEmpty);
    });
  });
}
