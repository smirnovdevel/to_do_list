import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';
import 'todos_provider.dart';

final Logging log = Logging('DoneProvider');

/// The different ways to filter the list of todos
enum TodosFilter {
  all,
  active,
}

/// The currently active filter.
///
/// We use [StateProvider] here as there is no fancy logic behind manipulating
/// the value since it's just enum.
final todosFilter = StateProvider((_) => TodosFilter.all);

/// The list of todos after applying of [todoListFilter].
///
/// This too uses [Provider], to avoid recomputing the filtered list unless either
/// the filter of or the todo-list updates.
final filteredTodos = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todosFilter);
  final todos = ref.watch(todosStateProvider) ?? [];

  log.info('Change filtered to: $filter');

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
