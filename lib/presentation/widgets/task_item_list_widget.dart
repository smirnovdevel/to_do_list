import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/common/app_icons.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../bloc/task_bloc.dart';
import '../../models/task.dart';
import '../screens/edit_page.dart';

class TaskItemListWidget extends StatefulWidget {
  TaskItemListWidget({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  State<TaskItemListWidget> createState() => _TaskItemListWidgetState();
}

class _TaskItemListWidgetState extends State<TaskItemListWidget> {
  final DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'ru');

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.task.delete
        ? Card(
            child: ListTile(
              leading: GestureDetector(
                  onTap: () {
                    widget.task.active = !widget.task.active;
                    context.read<TaskBloc>().add(UpdateTask(task: widget.task));
                    setState(() {});
                  },
                  child: _leading()),
              title: GestureDetector(
                  onTap: () {
                    _showEditTaskPage(context, widget.task);
                  },
                  child: _title()),
              subtitle: GestureDetector(
                  onTap: () {
                    _showEditTaskPage(context, widget.task);
                  },
                  child: _subtitle()),
              trailing: IconButton(
                onPressed: () {
                  _showEditTaskPage(context, widget.task);
                },
                icon: const Icon(AppIcons.infoOutline),
                color: Colors.grey,
              ),
            ),
          )
        : Container();
  }

  Widget _leading() {
    if (!widget.task.active) {
      return const Icon(AppIcons.checked, color: Colors.green);
    } else if (widget.task.priority == 2) {
      return const Icon(AppIcons.unchecked, color: Color(0xFFFF3B30));
    } else {
      return const Icon(AppIcons.unchecked, color: Colors.grey);
    }
  }

  Widget _title() {
    if (!widget.task.active) {
      return Text(
        widget.task.title,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
          color: Colors.grey,
          decoration: TextDecoration.lineThrough,
          decorationColor: Colors.grey,
          decorationStyle: TextDecorationStyle.solid,
        ),
      );
    }
    switch (widget.task.priority) {
      case 1:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              AppIcons.arrowDown,
              size: 14.0,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.5),
              child: Text(widget.task.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 18.0)),
            ),
          ],
        );
      case 2:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              AppIcons.priority,
              size: 16.0,
              color: Color(0xFFFF3B30),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(widget.task.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 18.0)),
            ),
          ],
        );
      default:
        return Text(
          widget.task.title,
        );
    }
  }

  Widget? _subtitle() {
    if (widget.task.unlimited) {
      return null;
    }
    return Text(
      dateFormat.format(widget.task.deadline),
      style: widget.task.active
          ? const TextStyle(color: Colors.blue)
          : const TextStyle(color: Colors.grey),
    );
  }

  Future<void> _showEditTaskPage(BuildContext context, TaskModel task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPage(task: task, isCreate: false),
      ),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.

    if (result != null) {
      if (result.delete) {
        context.read<TaskBloc>().add(DeleteTask(task: result));
      } else {
        context.read<TaskBloc>().add(UpdateTask(task: result));
      }
      setState(() {});
    }
  }
}
