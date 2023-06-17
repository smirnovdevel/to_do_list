import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';
import '../../common/app_icons.dart';
import '../../models/task.dart';
import '../../routes/navigation.dart';

class RowDeleteItemWidget extends StatelessWidget {
  const RowDeleteItemWidget({
    super.key,
    required this.task,
  });

  final TaskModel task;

  void _onGoBack(TaskModel? task) {
    NavigationManager.instance.pop(task);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0, left: 8.0),
      child: GestureDetector(
        onTap: () {
          if (task.id != null) {
            task.deleted = true;
            context.read<TaskBloc>().add(DeleteTask(task: task));
            _onGoBack(task);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  AppIcons.delete,
                  color: task.id == null
                      ? Theme.of(context).colorScheme.outlineVariant
                      : Theme.of(context).colorScheme.onSecondary,
                  size: 21.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Удалить',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        height: 20 / 16,
                        fontFamily: 'Roboto',
                        color: task.id == null
                            ? Theme.of(context).colorScheme.outlineVariant
                            : Theme.of(context).colorScheme.onSecondary),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: task.upload
                  ? const Icon(
                      Icons.cloud_done_outlined,
                      size: 26.0,
                    )
                  : const Icon(
                      Icons.cloud_off_outlined,
                      size: 26.0,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
