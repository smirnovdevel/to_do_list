import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/task_bloc.dart';
import '../../common/app_icons.dart';
import '../../models/task.dart';
import '../../routes/navigation.dart';

class RowDeleteItemWidget extends StatelessWidget {
  const RowDeleteItemWidget({
    super.key,
    required bool isCreate,
    required this.task,
  }) : _isCreate = isCreate;

  final bool _isCreate;
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
          if (!_isCreate) {
            task.delete = true;
            context.read<TaskBloc>().add(DeleteTask(task: task));
            _onGoBack(task);
          }
        },
        child: Row(
          children: [
            Icon(
              AppIcons.delete,
              color: _isCreate ? Colors.grey : Colors.red,
              size: 21.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Удалить',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                    color: _isCreate ? Colors.grey : Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}
