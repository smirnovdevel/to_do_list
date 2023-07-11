import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/todo.dart';
import '../../domain/repositories/todo_service.dart';
import '../../locator.dart';
import '../../utils/core/logging.dart';
import '../../utils/error/exception.dart';
import 'message_provider.dart';
import 'todos_provider.dart';

final Logging log = Logging('TodosManager');

final todosManagerProvider = Provider(
  (ref) => TodosManager(
    ref.watch(todosStateProvider.notifier),
    ref.read(messageStateProvider.notifier),
  ),
);

class TodosManager {
  final TodosStateHolder _state;
  final MessageStateHolder _message;

  TodosManager(this._state, this._message);
  final TodoService _todoService = locator();

  Future<void> init() async {
    List<Todo> localTodosList = [];
    List<Todo> remoteTodosList = [];
    List<Todo> todos;
    log.info('init ...');
    // set autor
    await _todoService.setAutor();

    try {
      remoteTodosList = await _todoService.getRemoteTodosList();
    } on ServerException catch (ex) {
      _message.warning(ex.toString());
    } catch (e) {
      log.warning(e.toString());
    }
    try {
      localTodosList = await _todoService.getLocalTodosList();
    } on DBException catch (ex) {
      _message.warning(ex.toString());
    } catch (e) {
      log.warning(e.toString());
    }

    todos = await _todoService.matchingTodos(
        local: localTodosList, remote: remoteTodosList);
    try {
      await _todoService.uploadTodosRemote(todos: todos);
    } on ServerException catch (ex) {
      _message.warning(ex.toString());
    } catch (e) {
      log.warning(e.toString());
    }

    _state.init(todos: todos);
  }

  Future<void> addTodo({required Todo todo}) async {
    log.info('Save todo uuid: ${todo.uuid} ...');
    // добавляем в список на экране
    _state.addTodo(todo: todo);
    Todo? task;
    // Выгружаем на сервер
    try {
      task = await _todoService.uploadTodoRemote(todo: todo);
    } on ServerException catch (ex) {
      log.warning(ex.toString());
    } catch (e) {
      log.warning(e.toString());
    }
    task ??= todo;
    // Сохраняем в DB
    _todoService.saveTodoDB(todo: task);
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
    // Выгружаем на сервер
    try {
      task = await _todoService.uploadTodoRemote(todo: todo);
    } on ServerException catch (ex) {
      log.warning(ex.toString());
    } catch (e) {
      log.warning(e.toString());
    }
    task ??= todo;
    // Сохраняем в DB
    _todoService.saveTodoDB(todo: task);
    if (!todo.upload && task.upload) {
      _state.updateTodo(todo: task);
    }
    log.info('Todo upload: ${task.upload}');
  }

  Future<void> deleteTodo({required Todo todo}) async {
    log.info('Delete todo uuid: ${todo.uuid} ...');
    // удаляем из списка на экране
    _state.deleteTodo(todo: todo);
    // Удаляем с сервера
    bool? result;
    try {
      result = await _todoService.deleteTodoRemote(todo: todo);
    } on ServerException catch (ex) {
      log.warning(ex.toString());
    } catch (e) {
      log.warning(e.toString());
    }
    result ??= false;
    _todoService.deleteTodoDB(todo: todo, deleted: result);
    log.info('Delete todo');
  }
}
