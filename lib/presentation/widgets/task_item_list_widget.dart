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
  late DateFormat dateFormat;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    dateFormat = DateFormat('dd MMMM yyyy', 'ru');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
            onPressed: null,
            icon: Icon(
                widget.task.active ? AppIcons.unchecked : AppIcons.checked)),
        title: widget.task.priority == 0
            ? Text(widget.task.title)
            : RichText(
                text: TextSpan(
                    text: '!!',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    children: [TextSpan(text: widget.task.title)]),
              ),
        subtitle: widget.task.unlimited
            ? null
            : Text(
                dateFormat.format(widget.task.deadline),
                style: const TextStyle(color: Colors.blue),
              ),
        trailing: IconButton(
          onPressed: () {
            _showEditTaskPage(context, widget.task);
          },
          icon: const Icon(AppIcons.infoOutline),
          color: Colors.grey,
        ),
      ),
    );
  }

  Future<void> _showEditTaskPage(BuildContext context, TaskModel task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTaskPage(task)),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.

    if (result != null) {
      // Is new task
      context.read<TaskBloc>().add(UpdateTask(task: result));
    }
  }
}
