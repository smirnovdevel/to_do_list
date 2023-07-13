import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';

final Logging log = Logging('currentTodoProvider');

// For desktop/landscape

final currentTodoProvider = StateProvider<Todo?>((_) => null);

// final currentTodoProvider = Provider<Todo?>((ref) {
//   final todos = ref.watch(filteredTodosProvider);
//   final todo = ref.watch(currentTodo);

//   log.info('Change current todo');

//   if (todo == null && todos.isNotEmpty) {
//     ref.read(currentTodo.notifier).state = todos.first;
//     return todos.first;
//   }
//   return todo;
// });
