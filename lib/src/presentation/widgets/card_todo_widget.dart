import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/common/app_icons.dart';
import '../../config/routes/dialogs.dart';
import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';
import '../provider/navigation_provider.dart';
import '../provider/todos_manager.dart';
import 'icon_done_widget.dart';
import 'subtitle_widget.dart';
import 'swipe_action_left_widget.dart';
import 'swipe_action_right_widget.dart';
import 'title_todo_widget.dart';

final Logging log = Logging('ItemTodoWidget');

class CardTodoWidget extends ConsumerStatefulWidget {
  const CardTodoWidget({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  ConsumerState<CardTodoWidget> createState() => _ItemTodoWidgetState();
}

class _ItemTodoWidgetState extends ConsumerState<CardTodoWidget> {
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
          changed: DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch),
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
        final double offset = (width - 16) * details.progress;
        if (offset >= 72) {
          setState(() {
            _padding = offset - 72;
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
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: IconDoneTodoWidget(todo: widget.todo),
                ),
              ),

              ///
              /// Title & Subtitle Widgets
              ///
              GestureDetector(
                onTap: () {
                  ref.read(navigationProvider).showTodo(widget.todo.uuid);
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 120,
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

              ///
              /// Icon Information
              ///
              GestureDetector(
                onTap: () {
                  ref.read(navigationProvider).showTodo(widget.todo.uuid);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Icon(
                    AppIcons.infoOutline,
                    color: Theme.of(context).colorScheme.inverseSurface,
                    weight: 19.97,
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
