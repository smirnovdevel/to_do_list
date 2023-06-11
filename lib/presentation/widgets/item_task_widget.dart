import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../bloc/task_bloc.dart';
import '../../common/app_icons.dart';
import '../../models/task.dart';
import '../../routes/navigation.dart';
import 'icon_activity_widget.dart';
import 'subtitle_widget.dart';
import 'title_widget.dart';

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

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.task.delete) {
      return Container();
    }
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
    );
  }

  Future<void> _onOpenEditPage(TaskModel task) async {
    final result = await NavigationManager.instance.openEditPage(task);
    if (result != null) {
      setState(() {});
    }
  }
}
