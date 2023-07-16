import 'package:flutter/material.dart';

import '../../../domain/models/todo.dart';
import 'subtitle_widget.dart';
import 'title_todo_widget.dart';

class TitleSubtitleWidget extends StatelessWidget {
  const TitleSubtitleWidget({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitletTodoWidget(todo: todo),
          SubtitleTodoWidget(todo: todo),
        ],
      ),
    );
  }
}
