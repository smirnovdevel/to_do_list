import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/task.dart';

class SubTitleWidget extends StatelessWidget {
  const SubTitleWidget({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    if (task.unlimited) {
      return Container();
    }
    return Text(
      DateFormat('dd MMMM yyyy', 'ru').format(task.deadline),
      style: task.active
          ? const TextStyle(color: Colors.blue)
          : const TextStyle(color: Colors.grey),
    );
  }
}
