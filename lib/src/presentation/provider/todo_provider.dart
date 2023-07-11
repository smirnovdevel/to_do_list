import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';
import 'todos_provider.dart';

final Logging log = Logging('FamilyProvider');

/// При открытии окна редактирования задачи, идет поиск по uuid
/// если такой не найдено, создаётся пустая
///
final todoProvider = Provider.family<Todo, String>((ref, uuid) {
  log.info('uuid: $uuid');
  final todos = ref.watch(todosStateProvider) ?? [];
  Todo todo = todos.firstWhere((item) => item.uuid == uuid, orElse: () {
    log.info('uuid: $uuid not found');
    return Todo(
      uuid: uuid,
      title: '',
      done: false,
      created: DateTime.now().toLocal().millisecondsSinceEpoch,
      changed: null,
      deviceId: null,
    );
  });
  return todo;
});
