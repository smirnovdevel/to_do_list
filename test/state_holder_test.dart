import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/src/domain/models/todo.dart';
import 'package:to_do_list/src/presentation/provider/todos_provider.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();
DateTime dateTimeNow =
    DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);

main() {
  ///
  /// Arrange
  ///
  TodosStateHolder todosStateHolder = TodosStateHolder();
  Todo todo = Todo(
      uuid: uuid.v1(),
      title: 'Test todo',
      done: false,
      importance: 'basic',
      deadline: dateTimeNow,
      deleted: false,
      created: dateTimeNow,
      changed: dateTimeNow,
      upload: false,
      autor: 'Test');

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
