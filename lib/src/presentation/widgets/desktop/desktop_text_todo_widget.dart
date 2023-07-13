import 'package:flutter/material.dart';

import '../../../domain/models/todo.dart';

///
/// Widget title item todo in list
///
class DesktopTitletTodoWidget extends StatelessWidget {
  const DesktopTitletTodoWidget({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    ///
    /// Disactivate todo icon
    ///
    if (todo.done) {
      return Text(
        todo.title,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        maxLines: 3,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          // fontSize: 19.0,
          color: Colors.grey,
          decoration: TextDecoration.lineThrough,
          decorationColor: Colors.grey,
          decorationStyle: TextDecorationStyle.solid,
        ),
      );
    }

    return Text(
      todo.title.replaceAll('\n', ' '),
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      maxLines: 3,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
