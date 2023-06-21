import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/common/app_icons.dart';
import '../../config/routes/dialogs.dart';
import '../../config/routes/navigation.dart';
import '../../domain/models/todo.dart';
import '../provider/todos_provider.dart';
import 'icon_done_widget.dart';
import 'subtitle_widget.dart';
import 'swipe_action_left_widget.dart';
import 'swipe_action_right_widget.dart';
import 'title_todo_widget.dart';

final Logger log = Logger('ItemTaskWidget');

class ItemTodoWidget extends ConsumerStatefulWidget {
  const ItemTodoWidget({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  ConsumerState<ItemTodoWidget> createState() => _ItemTaskWidgetState();
}

class _ItemTaskWidgetState extends ConsumerState<ItemTodoWidget> {
  double _padding = 0;

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  _changeDone() {
    ref
        .read(todosProvider.notifier)
        .edit(todo: widget.todo.copyWith(done: !widget.todo.done));
  }

  _deleteTodo() {
    ref.read(todosProvider.notifier).delete(todo: widget.todo);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    /// Swipe
    ///
    return Dismissible(
      key: Key(widget.todo.uuid!),

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
            _deleteTodo();
          }
          return confirmed;
        } else if (direction == DismissDirection.startToEnd) {
          _changeDone();
        }
        return false;
      },

      /// item task
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
                  _changeDone();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: IconDoneTodoWidget(todo: widget.todo),
                ),
              ),
              // ),

              /// Title & Subtitle
              ///
              GestureDetector(
                onTap: () {
                  _onOpenEditPage(widget.todo);
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
              GestureDetector(
                onTap: () {
                  _onOpenEditPage(widget.todo);
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

  Future<void> _onOpenEditPage(Todo todo) async {
    final Todo? result = await NavigationManager.instance.openEditPage(todo);
    if (result != null) {
      if (result.deleted) {
        _deleteTodo();
      } else {
        ref.read(todosProvider.notifier).edit(todo: Todo.copyFrom(result));
      }
    }
  }
}
