import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../config/common/app_icons.dart';
import '../../../utils/core/logging.dart';
import '../../provider/current_todo_provider.dart';
import '../../provider/navigation_provider.dart';
import '../../provider/todos_manager.dart';
import '../../provider/todos_provider.dart';
import '../../widgets/desktop/desktop_list_todo_widget.dart';
import '../../widgets/desktop/desktop_search_field.dart';
import '../../widgets/loading_indicator.dart';

final Logging log = Logging('DesktopMainScreen');
Uuid uuid = const Uuid();

class DesktopMainScreen extends ConsumerWidget {
  const DesktopMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosStateProvider);
    final todo = ref.watch(currentTodoProvider);
    if (todos == null) {
      ref.watch(todosManagerProvider).init();
    }
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: todos == null
              ? loadingIndicator()
              : const DesktopListTodoWidget(),
        ),
        Expanded(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Column(
                children: [
                  const DesktopSearchField(),
                  Center(
                    child: Text(todo == null ? '' : todo.title),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                ref.read(navigationProvider).showTodo(uuid.v1());
              },
              tooltip: 'Add_todo',
              backgroundColor: Theme.of(context).iconTheme.color,
              child: const Icon(
                AppIcons.add,
                color: Colors.white,
                weight: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
