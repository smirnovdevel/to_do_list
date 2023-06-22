import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../locator.dart';
import '../../domain/models/todo.dart';
import '../../domain/repositories/todo_service.dart';
import '../../utils/core/logging.dart';

final Logging log = Logging('TodosProvider');

final todosUpdated = StateProvider((_) => false);

/// Creates a [TodoList] and initialise it with pre-defined values.
///
/// We are using [StateNotifierProvider] here as a `List<Todo>` is a complex
/// object, with advanced business logic like how to edit a todo.
final todosProvider = StateNotifierProvider<TodoList, List<Todo>?>(
  (ref) {
    return TodoList();
  },
);

/// An object t
/// hat controls a list of [Todo].
class TodoList extends StateNotifier<List<Todo>?> {
  TodoList([List<Todo>? empty]) : super(empty);

  final TodoService _todoService = locator();

  Future<void> add({required Todo todo}) async {
    log.info('Add todo uuid: ${todo.uuid} ...');
    state = [
      ...state ??= [],
      todo,
    ];
    final task = await _todoService.saveTodo(todo: todo);
    if (task.upload) {
      state = [
        for (final item in state ?? [])
          if (item.uuid == task.uuid) Todo.copyFrom(task) else item,
      ];
    }
    log.info('Todo upload: ${task.upload}');
    log.info('Add todo');
  }

  Future<void> save({required Todo todo}) async {
    log.info('Edit todo uuid: ${todo.uuid} ...');
    state = [
      for (final item in state ?? [])
        if (item.uuid == todo.uuid) Todo.copyFrom(todo) else item,
    ];
    final task = await _todoService.saveTodo(todo: todo);
    state = [
      for (final item in state ?? [])
        if (item.uuid == task.uuid) Todo.copyFrom(task) else item,
    ];
    log.info('Todo upload: ${task.upload}');
    log.info('Edit todo');
  }

  Future<void> delete({required Todo todo}) async {
    log.info('Delete todo uuid: ${todo.uuid} ...');
    state = state?.where((item) => item.uuid != todo.uuid).toList();
    _todoService.deleteTodo(todo: todo);
    log.info('Delete todo');
  }

  Future<void> init() async {
    log.info('init ...');
    await _todoService.getId();
    state = await _todoService.getTodos();
  }
}
