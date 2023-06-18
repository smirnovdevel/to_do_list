import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/task.dart';

class SubTitleWidget extends StatelessWidget {
  const SubTitleWidget({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    if (task.deadline == null) {
      return Container();
    }
    return Text(
      DateFormat('dd MMMM yyyy', 'ru').format(task.deadline!),
      style: task.done
          ? const TextStyle(color: Colors.grey)
          : const TextStyle(color: Colors.blue),
    );
  }
}
