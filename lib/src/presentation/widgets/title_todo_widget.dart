import 'package:flutter/material.dart';

import '../../config/common/app_icons.dart';
import '../../domain/models/todo.dart';

///
/// Widget title item todo in list
///
class TitletTodoWidget extends StatelessWidget {
  const TitletTodoWidget({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    ///
    /// Disactivate todo icon
    ///
    if (todo.done) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
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
            ),
          ),
        ],
      );
    }

    ///
    /// Todo low priority icon
    ///
    switch (todo.importance) {
      case Priority.low:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 4.5, right: 5.5),
              child: Icon(
                AppIcons.arrowDown,
                size: 16.0,
                color: Colors.grey,
              ),
            ),
            Flexible(
              child: Text(todo.title,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        );

      ///
      /// Todo high priority icon
      ///
      case Priority.important:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.5, right: 6.0),
              child: Icon(
                AppIcons.priority,
                size: 18.0,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
            ),
            Flexible(
              child: Text(
                todo.title,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        );

      ///
      /// Todo without priority icon
      ///
      default:
        return Row(
          children: [
            Flexible(
              child: Text(
                todo.title,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        );
    }
  }
}
