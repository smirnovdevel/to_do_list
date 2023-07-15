import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/core/logging.dart';
import '../../provider/current_todo_provider.dart';
import 'tablet_view_todo_widget.dart';
import 'tablet_edit_todo_widget.dart';
import 'tablet_emty_todo_widget.dart';

final Logging log = Logging('TabletSwitcherWidget');

class TabletSwitcherWidget extends ConsumerWidget {
  const TabletSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(choiseTodoProvider);
    final edit = ref.watch(editTodoProvider);
    if (todo == null) {
      log.debug('Change todo empty');
    } else if (edit) {
      log.debug('Change todo edit ${todo.uuid}');
    } else {
      log.debug('Change todo view ${todo.uuid}');
    }

    return Scaffold(
      body: AnimatedSwitcher(
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
        child: todo == null
            ? const TabletEmptyWidget()
            : edit
                ? TabletEditTodoWidget(todo: todo)
                : const TabletViewTodoWidget(),
      ),
    );
  }
}
