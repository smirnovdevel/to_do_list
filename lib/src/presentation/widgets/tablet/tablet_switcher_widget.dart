import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/current_todo_provider.dart';
import 'tablet_view_todo_widget.dart';
import 'tablet_edit_todo_widget.dart';
import 'tablet_emty_todo_widget.dart';

class TabletSwitcherWidget extends ConsumerWidget {
  const TabletSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(currentTodoProvider);
    final edit = ref.watch(editTodoProvider);
    return Scaffold(
      body: AnimatedSwitcher(
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
        child: todo == null
            ? const TabletEmptyWidget()
            : edit
                ? TabletEditTodoWidget(uuid: todo.uuid)
                : const TabletViewTodoWidget(),
      ),
    );
  }
}
