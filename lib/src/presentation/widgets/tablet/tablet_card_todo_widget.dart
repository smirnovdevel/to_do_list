import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/routes/dialogs.dart';
import '../../../domain/models/todo.dart';
import '../../../utils/core/logging.dart';
import '../../provider/current_todo_provider.dart';
import '../../provider/navigation_provider.dart';
import '../../provider/todos_manager.dart';
import '../common_widgets/desktop_title_subtitle_widget.dart';
import '../desktop/desktop_icon_done_widget.dart';
import '../desktop/desktop_icon_information_widget.dart';
import '../desktop/desktop_swipe_action_left_widget.dart';
import '../desktop/desktop_swipe_action_right_widget.dart';

final Logging log = Logging('DesktopCardTodoWidget');

class TabletCardTodoWidget extends ConsumerStatefulWidget {
  const TabletCardTodoWidget({
    super.key,
    required this.todo,
    required this.index,
  });

  final Todo todo;
  final int index;

  @override
  ConsumerState<TabletCardTodoWidget> createState() => _ItemTodoWidgetState();
}

class _ItemTodoWidgetState extends ConsumerState<TabletCardTodoWidget> {
  double _padding = 0;
  bool animation = false;

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        animation = true;
      });
    });
  }

  _changeDone(Todo todo) {
    ref.watch(todosManagerProvider).updateTodo(
          todo: widget.todo.copyWith(
            done: !todo.done,
            changed: DateTime.now().toLocal().millisecondsSinceEpoch,
          ),
        );
    ref.read(currentTodoProvider.notifier).state = todo;
  }

  _deleteTodo(Todo todo) {
    if (ref.read(currentTodoProvider)?.uuid == todo.uuid) {
      ref.read(currentTodoProvider.notifier).state = null;
      ref.read(editTodoProvider.notifier).state = false;
    }
    ref.watch(todosManagerProvider).deleteTodo(todo: todo);
  }

  @override
  Widget build(BuildContext context) {
    final todo = ref.watch(currentTodoProvider);
    final double width = MediaQuery.of(context).size.width;

    /// Swipe
    ///
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 600 + (widget.index * 100)),
      transform: Matrix4.translationValues(animation ? 0 : -width, 0, 0),
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Dismissible(
        key: Key(widget.todo.uuid),

        /// swipe left
        ///
        secondaryBackground: DesktopSwipeActionLeftWidget(
          padding: _padding,
        ),

        /// swipe right
        ///
        background: DesktopSwipeActionRightWidget(padding: _padding),
        onUpdate: (DismissUpdateDetails details) {
          final double offset = (width / 3 * 2 - 46) * details.progress;
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
        child: InkWell(
          onTap: () {
            ref.watch(currentTodoProvider.notifier).state = widget.todo;
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: todo == null
                    ? Theme.of(context).colorScheme.primary
                    : widget.todo.uuid == todo.uuid
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.primary,
                width: 0.5,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 12.0),
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
                  TitleSubtitleWidget(todo: widget.todo),
                  const SizedBox(width: 8),

                  ///
                  /// Icon Information
                  ///
                  GestureDetector(
                    onTap: () {
                      ref.read(navigationProvider).showTodo(widget.todo.uuid);
                    },
                    child: const DesktopIconInformationWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
