import 'package:to_do_list/src/domain/models/todo.dart';
import 'package:to_do_list/src/utils/core/logging.dart';

import '../todos_mock.dart';

final Logging log = Logging('HttpMock');

class HttpMock {
  List<Todo> remoteTodos = [];

  void init(int num) {
    remoteTodos.addAll(todosMock(num: num));
  }

  Future<List<Todo>> get() async {
    return remoteTodos;
  }

  Future<List<Todo>> getTodos() async {
    return remoteTodos;
  }

  Future<Todo?> getTodo({required String uuid}) async {
    Todo? todo;
    try {
      todo = remoteTodos.firstWhere((todo) => todo.uuid == uuid);
    } catch (e) {
      log.warning(e.toString());
    }
    return todo;
  }

  Future<bool> updateTodos({required List<Todo> todos}) async {
    remoteTodos.clear();
    for (Todo todo in todos) {
      remoteTodos.add(todo.copyWith(upload: true));
    }
    return true;
  }

  Future<Todo> saveTodo({required Todo todo}) async {
    remoteTodos.add(todo.copyWith(upload: true));
    return todo.copyWith(upload: true);
  }

  Future<Todo> updateTodo({required Todo todo}) async {
    int idx = remoteTodos.indexWhere((item) => item.uuid == todo.uuid);
    remoteTodos[idx] = todo.copyWith(upload: true);
    return remoteTodos[idx];
  }

  Future<bool> deleteTodo({required Todo todo}) async {
    try {
      remoteTodos.removeWhere((item) => item.uuid == todo.uuid);
    } catch (e) {
      log.warning(e.toString());
    }

    return true;
  }
}
