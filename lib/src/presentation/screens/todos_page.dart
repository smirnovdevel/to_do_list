import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/core/logging.dart';
import '../provider/todos_manager.dart';
import '../provider/todos_provider.dart';
import '../widgets/list_todo_widget.dart';
import '../widgets/loading_indicator.dart';

final Logging log = Logging('HomePage');

class TodosPage extends ConsumerWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosStateProvider);
    if (todos == null) {
      ref.watch(todosManagerProvider).init();
    }
    return todos == null ? loadingIndicator() : const ListTodoWidget();
  }
}
