import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/routes/dialogs.dart';
import '../../../domain/models/todo.dart';
import '../../../utils/core/logging.dart';
import '../../provider/navigation_provider.dart';
import '../../provider/todos_manager.dart';
import '../common_widgets/desktop_title_subtitle_widget.dart';
import 'mobile_icon_information_widget.dart';
import 'mobile_swipe_action_left_widget.dart';
import 'mobile_swipe_action_right_widget.dart';
import 'mobile_icon_done_widget.dart';

final Logging log = Logging('MobileCardTodoWidget');

class MobileCardTodoWidget extends ConsumerStatefulWidget {
  const MobileCardTodoWidget({
    super.key,
    required this.todo,
    required this.index,
  });

  final Todo todo;
  final int index;

  @override
  ConsumerState<MobileCardTodoWidget> createState() => _ItemTodoWidgetState();
}

class _ItemTodoWidgetState extends ConsumerState<MobileCardTodoWidget> {
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
        ));
  }

  _deleteTodo(Todo todo) {
    ref.watch(todosManagerProvider).deleteTodo(todo: todo);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    /// Swipe
    ///
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 400 + (widget.index * 100)),
      transform: Matrix4.translationValues(0, animation ? 0 : height, 0),
      padding: const EdgeInsets.only(bottom: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) => Dismissible(
          key: Key(widget.todo.uuid!),

          /// swipe left
          ///
          secondaryBackground: MobileSwipeActionLeftWidget(
            padding: _padding,
          ),

          /// swipe right
          ///
          background: MobileSwipeActionRightWidget(padding: _padding),
          onUpdate: (DismissUpdateDetails details) {
            final double offset = constraints.maxWidth * details.progress;

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
          child: InkWell(
            onTap: () {
              ref.read(navigationProvider).showTodo(widget.todo.uuid!);
            },
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
                    InkWell(
                      onTap: () {
                        _changeDone(widget.todo);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 14.0, top: 2.0),
                        child: MobileIconDoneTodoWidget(todo: widget.todo),
                      ),
                    ),

                    ///
                    /// Title & Subtitle Widgets
                    ///
                    TitleSubtitleWidget(todo: widget.todo),

                    ///
                    /// Icon Information
                    ///
                    const MobileIconInformationWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
