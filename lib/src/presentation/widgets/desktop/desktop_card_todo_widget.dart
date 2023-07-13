import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/routes/dialogs.dart';
import '../../../domain/models/todo.dart';
import '../../../utils/core/logging.dart';
import '../../provider/current_todo_provider.dart';
import '../../provider/todos_manager.dart';
import 'desktop_icon_done_widget.dart';
import '../subtitle_widget.dart';
import '../swipe_action_left_widget.dart';
import '../swipe_action_right_widget.dart';
import '../title_todo_widget.dart';

final Logging log = Logging('MobileCardTodoWidget');

class DesktopCardTodoWidget extends ConsumerStatefulWidget {
  const DesktopCardTodoWidget({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  ConsumerState<DesktopCardTodoWidget> createState() => _ItemTodoWidgetState();
}

class _ItemTodoWidgetState extends ConsumerState<DesktopCardTodoWidget> {
  double _padding = 0;

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  _changeDone(Todo todo) {
    ref.watch(todosManagerProvider).updateTodo(
            todo: widget.todo.copyWith(
          done: !todo.done,
          changed: DateTime.now().toLocal().millisecondsSinceEpoch,
        ));
  }

  _deleteTodo(Todo todo) {
    ref.watch(todosManagerProvider).deleteTodo(todo: todo);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    /// Swipe
    ///
    return Dismissible(
      key: Key(widget.todo.uuid),

      /// swipe left
      ///
      secondaryBackground: SwipeActionLeftWidget(
        padding: _padding,
      ),

      /// swipe right
      ///
      background: SwipeActionRightWidget(padding: _padding),
      onUpdate: (DismissUpdateDetails details) {
        final double offset = (width / 3 * 2 - 46) * details.progress;
        print(offset);
        if (offset >= 86) {
          setState(() {
            _padding = offset - 86;
          });
        }
      },

      /// confirm and action
      ///
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          final bool confirmed =
              await Dialogs.showConfirmCloseCountDialog(context) ?? false;
          if (confirmed) {
            _deleteTodo(widget.todo);
          }
          return confirmed;
        } else if (direction == DismissDirection.startToEnd) {
          _changeDone(widget.todo);
        }
        return false;
      },

      /// item todo
      ///
      child: Material(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// Activity icon
              ///
              GestureDetector(
                onTap: () {
                  _changeDone(widget.todo);
                },
                child: DesktopIconDoneTodoWidget(todo: widget.todo),
              ),

              ///
              /// Title & Subtitle Widgets
              ///
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.watch(currentTodoProvider.notifier).state = widget.todo;
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitletTodoWidget(todo: widget.todo),
                      SubtitleTodoWidget(todo: widget.todo),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
