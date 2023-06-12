import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../bloc/task_bloc.dart';
import '../../common/app_icons.dart';
import '../../core/logging.dart';
import '../../models/task.dart';
import '../../routes/dialogs.dart';
import '../../routes/navigation.dart';
import 'icon_activity_widget.dart';
import 'subtitle_widget.dart';
import 'swipe_action_left_widget.dart';
import 'swipe_action_right_widget.dart';
import 'title_widget.dart';

final log = logger(ItemTaskWidget);

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
    widget.task.active = !widget.task.active;
    context.read<TaskBloc>().add(UpdateTask(task: widget.task));
    setState(() {});
  }

  _deleteCurrentTask() {
    widget.task.delete = true;
    context.read<TaskBloc>().add(DeleteTask(task: widget.task));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (widget.task.delete) {
      return Container();
    }
    return Dismissible(
      key: Key(widget.task.id.toString()),
      secondaryBackground: SwipeActionLeftWidget(
        padding: _padding,
      ),
      // background: slideRightBackground(),
      background: SwipeActionRightWidget(padding: _padding),
      onUpdate: (details) {
        final offset = (width - 16) * details.progress;
        if (offset >= 72) {
          setState(() {
            _padding = offset - 72;
          });
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          if (!widget.task.active) {
            _deleteCurrentTask();
            return true;
          }
          final confirmed =
              await Dialogs.showConfirmCloseCountDialog(context) ?? false;
          if (confirmed) {
            _deleteCurrentTask();
          }
          return confirmed;
        } else if (direction == DismissDirection.startToEnd) {
          _changeActivityTask();
        }
        return false;
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 19.0, bottom: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _changeActivityTask();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [IconActivityWidget(task: widget.task)],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _onOpenEditPage(widget.task);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 14.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitletWidget(task: widget.task),
                            SubTitleWidget(task: widget.task),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 17.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              AppIcons.infoOutline,
                              color: Colors.grey,
                              weight: 19.97,
                            ),
                          ],
                        ),
                      ),
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

  Future<void> _onOpenEditPage(TaskModel task) async {
    final result = await NavigationManager.instance.openEditPage(task);
    if (result != null) {
      setState(() {});
    }
  }
}
