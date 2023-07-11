import 'package:to_do_list/src/domain/models/todo.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();
int unixTimeStamp = DateTime.now().toLocal().millisecondsSinceEpoch;

class TodoMock {
  Todo get({required String title}) {
    return Todo(
        uuid: uuid.v1(),
        title: title,
        done: false,
        deadline: unixTimeStamp,
        created: unixTimeStamp,
        changed: unixTimeStamp,
        upload: true,
        deviceId: 'Test');
  }
}
