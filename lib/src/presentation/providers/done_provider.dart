import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';
import 'todos_provider.dart';

final Logging log = Logging('DoneProvider');

/// Варианты отбора в списке задач
enum TodosFilter {
  all,
  active,
}

/// The currently active filter.
final todosFilter = StateProvider((_) => TodosFilter.all);

final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todosFilter);
  final todos = ref.watch(todosStateProvider) ?? [];

  log.debug('Change filtered to: $filter');

  switch (filter) {
    case TodosFilter.active:
      return todos.where((todo) => !todo.done).toList();
    case TodosFilter.all:
      return todos;
  }
});

final countDone = StateProvider<int>((ref) {
  final todos = ref.watch(todosStateProvider) ?? [];
  return todos.where((Todo todo) => todo.done && !todo.deleted).length;
});
