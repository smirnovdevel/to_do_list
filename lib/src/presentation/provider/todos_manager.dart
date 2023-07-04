import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/todo.dart';
import '../../domain/repositories/todo_service.dart';
import '../../locator.dart';
import '../../utils/core/logging.dart';
import '../../utils/error/exception.dart';
import 'todos_provider.dart';

final Logging log = Logging('TodosManager');

// TODO Менеджеры всегда отвечают за обработку ошибок

final todosManagerProvider =
    Provider((ref) => TodosManager(ref.watch(todosStateProvider.notifier)));

class TodosManager {
  final TodosStateHolder _state;

  TodosManager(this._state);
  final TodoService _todoService = locator();

  Future<void> init() async {
    log.info('init ...');
    await _todoService.getId();
    List<Todo>? todos;
    try {
      todos = await _todoService.getTodos();
    } catch (e) {
      log.warning(e.toString());
    }
    todos ??= [];
    _state.init(todos: todos);
  }

  Future<void> addTodo({required Todo todo}) async {
    log.info('Save todo uuid: ${todo.uuid} ...');
    // добавляем в список на экране
    _state.addTodo(todo: todo);
    Todo? task;
    try {
      task = await _todoService.saveTodo(todo: todo);
    } catch (e) {
      log.warning(e.toString());
    }
    task ??= todo;
    if (!todo.upload && task.upload) {
      _state.updateTodo(todo: task);
    }
    log.info('Todo upload: ${task.upload}');
  }

  Future<void> updateTodo({required Todo todo}) async {
    log.info('Update todo uuid: ${todo.uuid} ...');
    // обновляем в списке на экране
    _state.updateTodo(todo: todo);
    Todo? task;
    try {
      task = await _todoService.saveTodo(todo: todo);
    } catch (e) {
      log.warning(e.toString());
    }
    task ??= todo;
    if (!todo.upload && task.upload) {
      _state.updateTodo(todo: task);
    }
    log.info('Todo upload: ${task.upload}');
  }

  Future<void> deleteTodo({required Todo todo}) async {
    log.info('Delete todo uuid: ${todo.uuid} ...');
    // удаляем из списка на экране
    _state.deleteTodo(todo: todo);
    try {
      await _todoService.deleteTodo(todo: todo);
    } catch (e) {
      log.warning(e.toString());
    }
    log.info('Delete todo');
  }
}
