import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/todo.dart';

class SubtitleTodoWidget extends StatelessWidget {
  const SubtitleTodoWidget({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    if (todo.deadline == null) {
      return Container();
    }
    return Text(
      DateFormat('dd MMMM yyyy', 'ru').format(todo.deadline!),
      style: todo.done
          ? const TextStyle(color: Colors.grey)
          : const TextStyle(color: Colors.blue),
    );
  }
}
