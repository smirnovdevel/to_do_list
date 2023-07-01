import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';

final Logging log = Logging('TodosProvider');

final todosUpdated = StateProvider((_) => false);

/// Creates a [TodoList] and initialise it with pre-defined values.
///
/// We are using [StateNotifierProvider] here as a `List<Todo>` is a complex
/// object, with advanced business logic like how to edit a todo.
final todosStateProvider = StateNotifierProvider<TodosStateHolder, List<Todo>?>(
  (ref) => TodosStateHolder(),
);

/// An object t
/// hat controls a list of [Todo].
class TodosStateHolder extends StateNotifier<List<Todo>?> {
  TodosStateHolder([List<Todo>? empty]) : super(empty);

  void addTodo({required Todo todo}) {
    log.info('Save todo uuid: ${todo.uuid}');
    state = [
      ...state ??= [],
      todo,
    ];
  }

  void updateTodo({required Todo todo}) {
    log.info('Update todo uuid: ${todo.uuid}');
    state = [
      for (Todo item in state ?? [])
        if (item.uuid == todo.uuid) Todo.copyFrom(todo) else item,
    ];
  }

  void deleteTodo({required Todo todo}) {
    log.info('Delete todo uuid: ${todo.uuid}');
    state = state?.where((item) => item.uuid != todo.uuid).toList();
  }

  void init({required List<Todo> todos}) {
    log.info('Loaded');
    state = todos;
  }
}
