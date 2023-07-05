import 'package:to_do_list/src/domain/models/todo.dart';

import 'todo_mock.dart';

TodoMock todoMock = TodoMock();

List<Todo> todosMock({required int num}) {
  List<Todo> todos = [];
  for (int i = 0; i < num; i++) {
    todos.add(todoMock.get(title: 'This test todo #$i'));
  }
  return todos;
}
