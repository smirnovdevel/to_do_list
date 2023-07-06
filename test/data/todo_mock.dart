import 'package:to_do_list/src/domain/models/todo.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class TodoMock {
  Todo get({required String title}) {
    return Todo(
        uuid: uuid.v1(),
        title: title,
        done: false,
        priority: 0,
        deadline: DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch),
        deleted: false,
        created: DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch),
        changed: DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch),
        upload: true,
        autor: 'Test');
  }
}
