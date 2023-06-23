import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/todo.dart';
import '../localization/app_localization.dart';

class SubtitleTodoWidget extends StatelessWidget {
  const SubtitleTodoWidget({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalization.of(context).locale.languageCode;
    if (todo.deadline == null) {
      return Container();
    }
    return Text(
      DateFormat('dd MMMM yyyy', locale).format(todo.deadline!),
      style: todo.done
          ? const TextStyle(color: Colors.grey)
          : const TextStyle(color: Colors.blue),
    );
  }
}
