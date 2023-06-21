import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../locator.dart';
import '../../domain/models/todo.dart';
import '../../domain/repositories/todo_service.dart';

/// Creates a [TodoList] and initialise it with pre-defined values.
///
/// We are using [StateNotifierProvider] here as a `List<Todo>` is a complex
/// object, with advanced business logic like how to edit a todo.
final todosProvider = StateNotifierProvider<TodoList, List<Todo>?>(
  (ref) {
    return TodoList();
  },
);

final Logger log = Logger('TodosProvider');

/// An object t
/// hat controls a list of [Todo].
class TodoList extends StateNotifier<List<Todo>?> {
  TodoList([List<Todo>? initialTodos]) : super(initialTodos);

  final TodoService _todoService = locator();

  void add(Todo todo) {
    log.info('Add todo uuid: ${todo.uuid} ...');
    state = [
      ...state ??= [],
      todo,
    ];
    log.info('Add todo');
  }

  void edit({required Todo todo}) {
    log.info('Edit todo uuid: ${todo.uuid} ...');
    state = [
      for (final item in state ?? [])
        if (item.uuid == todo.uuid) Todo.copyFrom(todo) else item,
    ];
    log.info('Edit todo');
  }

  void delete({required Todo todo}) {
    log.info('Delete todo uuid: ${todo.uuid} ...');
    state = state?.where((item) => item.uuid != todo.uuid).toList();
    log.info('Delete todo');
  }

  Future<void> init() async {
    log.info('init ...');
    state = await _todoService.getTasks();
  }
}
