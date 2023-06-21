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

  Future<void> add(Todo todo) async {
    log.info('Add todo uuid: ${todo.uuid} ...');
    await _todoService.saveTask(todo: todo);
    state = [
      ...state ??= [],
      todo,
    ];
    log.info('Add todo');
  }

  Future<void> edit({required Todo todo}) async {
    log.info('Edit todo uuid: ${todo.uuid} ...');
    todo = await _todoService.saveTask(todo: todo);
    log.info('Todo upload: ${todo.upload}');
    state = [
      for (final item in state ?? [])
        if (item.uuid == todo.uuid) Todo.copyFrom(todo) else item,
    ];
    log.info('Edit todo');
  }

  Future<void> delete({required Todo todo}) async {
    log.info('Delete todo uuid: ${todo.uuid} ...');
    await _todoService.deleteTask(todo: todo);
    state = state?.where((item) => item.uuid != todo.uuid).toList();
    log.info('Delete todo');
  }

  Future<void> init() async {
    log.info('init ...');
    state = await _todoService.getTasks();
  }
}
