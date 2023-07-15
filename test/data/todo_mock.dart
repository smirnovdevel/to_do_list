import 'package:to_do_list/src/domain/models/todo.dart';
import 'package:uuid/uuid.dart';

int unixTimeStamp = DateTime.now().toLocal().millisecondsSinceEpoch;

class TodoMock {
  Todo get({required String title}) {
    return Todo(
        // ignore: prefer_const_constructors
        uuid: Uuid().v1(),
        title: title,
        done: false,
        deadline: unixTimeStamp,
        created: unixTimeStamp,
        changed: unixTimeStamp,
        upload: true,
        deviceId: 'Test');
  }
}
