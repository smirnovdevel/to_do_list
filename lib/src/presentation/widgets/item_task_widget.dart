import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../config/common/app_icons.dart';
import '../../config/routes/dialogs.dart';
import '../../config/routes/navigation.dart';
import '../../domain/models/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../provider/task_provider.dart';
import 'icon_done_widget.dart';
import 'subtitle_widget.dart';
import 'swipe_action_left_widget.dart';
import 'swipe_action_right_widget.dart';
import 'title_widget.dart';

final Logger log = Logger('ItemTaskWidget');

class ItemTaskWidget extends StatefulWidget {
  const ItemTaskWidget({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  State<ItemTaskWidget> createState() => _ItemTaskWidgetState();
}

class _ItemTaskWidgetState extends State<ItemTaskWidget> {
  DateFormat dateFormat = DateFormat('dd MMMM yyyy');
  double _padding = 0;

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  _changeActivityTask() {
    setState(() {
      widget.task.done = !widget.task.done;
    });
    context.read<TaskBloc>().add(SaveTask(task: widget.task));
  }

  _deleteCurrentTask() {
    // setState(() {
    widget.task.deleted = true;
    // });
    context.read<TaskBloc>().add(DeleteTask(task: widget.task));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final TaskProvider provider = Provider.of<TaskProvider>(context);

    /// Hide complted task
    ///
    if (!provider.visible && widget.task.done) {
      return Container();
    }

    /// Swipe
    ///
    return Dismissible(
      key: Key(widget.task.uuid!),

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
            _deleteCurrentTask();
          }
          return confirmed;
        } else if (direction == DismissDirection.startToEnd) {
          _changeActivityTask();
          provider.changesStatusTask();
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
                  _changeActivityTask();
                  provider.changesStatusTask();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: IconDoneWidget(task: widget.task),
                ),
              ),
              // ),

              /// Title & Subtitle
              ///
              GestureDetector(
                onTap: () {
                  _onOpenEditPage(widget.task);
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitletWidget(task: widget.task),
                      SubTitleWidget(task: widget.task),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _onOpenEditPage(widget.task);
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

  Future<void> _onOpenEditPage(TaskModel task) async {
    final TaskModel? result =
        await NavigationManager.instance.openEditPage(task);
    if (result != null) {
      if (result.deleted) {
        _deleteCurrentTask();
      } else {
        setState(() {});
      }
    }
  }
}
