import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/common/app_icons.dart';
import '../../config/routes/dialogs.dart';
import '../../config/routes/navigation.dart';
import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';
import '../provider/todos_provider.dart';
import 'icon_done_widget.dart';
import 'subtitle_widget.dart';
import 'swipe_action_left_widget.dart';
import 'swipe_action_right_widget.dart';
import 'title_todo_widget.dart';

final Logging log = Logging('ItemTodoWidget');

class ItemTodoWidget extends ConsumerStatefulWidget {
  const ItemTodoWidget({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  ConsumerState<ItemTodoWidget> createState() => _ItemTodoWidgetState();
}

class _ItemTodoWidgetState extends ConsumerState<ItemTodoWidget> {
  double _padding = 0;

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  _changeDone(Todo todo) {
    ref.read(todosProvider.notifier).save(
        todo: widget.todo.copyWith(done: !todo.done, changed: DateTime.now()));
  }

  _saveTodo(Todo todo) {
    ref.read(todosProvider.notifier).save(todo: todo);
  }

  _deleteTodo(Todo todo) {
    ref.read(todosProvider.notifier).delete(todo: todo);
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
        _deleteTodo(result);
      } else {
        _saveTodo(result);
      }
    }
  }
}
