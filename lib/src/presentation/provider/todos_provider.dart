import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';

final Logging log = Logging('TodosProvider');

final todosStateProvider = StateNotifierProvider<TodosStateHolder, List<Todo>?>(
  (ref) => TodosStateHolder(),
);

class TodosStateHolder extends StateNotifier<List<Todo>?> {
  TodosStateHolder([List<Todo>? empty]) : super(empty);

  void init({required List<Todo> todos}) {
    log.info('Loaded');
    state = todos;
  }

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
}
