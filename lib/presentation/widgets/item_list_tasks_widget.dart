import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../bloc/task_bloc.dart';
import '../../common/app_icons.dart';
import '../../models/task.dart';
import '../../routes/navigation.dart';
import '../screens/edit_page.dart';

class ItemListTasks extends StatefulWidget {
  const ItemListTasks({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  State<ItemListTasks> createState() => _ItemListTasksState();
}

class _ItemListTasksState extends State<ItemListTasks> {
  DateFormat dateFormat = DateFormat('dd MMMM yyyy');

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 19.0, bottom: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                widget.task.active = !widget.task.active;
                context.read<TaskBloc>().add(UpdateTask(task: widget.task));
                setState(() {});
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [_activity()],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // _showEditTaskPage(widget.task);
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
                          _title(),
                          _subtitle(),
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
    );
  }

  Future<void> _onOpenEditPage(TaskModel task) async {
    final result = await NavigationManager.instance.openEditPage(task);
    // setState(() {
    //   _lastCount = result;
    // });
  }

  Widget _activity() {
    if (!widget.task.active) {
      return const Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Icon(
          AppIcons.checked,
          color: Colors.green,
          weight: 18.0,
        ),
      );
    } else if (widget.task.priority == 2) {
      return const Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Icon(
          AppIcons.unchecked,
          color: Color(0xFFFF3B30),
          weight: 18.0,
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Icon(
          AppIcons.unchecked,
          color: Colors.grey,
          weight: 18.0,
        ),
      );
    }
  }

  Widget _title() {
    if (!widget.task.active) {
      return Text(
        widget.task.title,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 19.0,
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
                      fontSize: 19.0)),
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
                      fontSize: 19.0)),
            ),
          ],
        );
      default:
        return Text(
          widget.task.title,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 19.0,
            color: Colors.black,
          ),
        );
    }
  }

  Widget _subtitle() {
    if (widget.task.unlimited) {
      return Container();
    }
    return Text(
      DateFormat('dd MMMM yyyy', 'ru').format(widget.task.deadline),
      style: widget.task.active
          ? const TextStyle(color: Colors.blue)
          : const TextStyle(color: Colors.grey),
    );
  }

  Future<void> _showEditTaskPage(TaskModel task) async {
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
        context.read()<TaskBloc>().add(DeleteTask(task: result));
      } else {
        context.read()<TaskBloc>().add(UpdateTask(task: result));
      }
      setState(() {});
    }
  }
}
