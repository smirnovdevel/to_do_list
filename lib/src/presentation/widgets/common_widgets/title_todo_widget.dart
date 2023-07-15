import 'package:flutter/material.dart';

import '../../../config/common/app_icons.dart';
import '../../../domain/models/todo.dart';
import '../../../utils/core/scale_size.dart';

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
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.grey,
                decorationStyle: TextDecorationStyle.solid,
              ),
              textScaleFactor: ScaleSize.textScaleFactor(context),
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
            Padding(
              padding: const EdgeInsets.only(top: 4.5, right: 5.5),
              child: Icon(
                AppIcons.arrowDown,
                size: 16.0 * ScaleSize.iconScaleFactor(context),
                color: Colors.grey,
              ),
            ),
            Flexible(
              child: Text(
                todo.title,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyMedium,
                textScaleFactor: ScaleSize.textScaleFactor(context),
              ),
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
              padding: const EdgeInsets.only(top: 1.0, right: 6.0),
              child: Icon(
                AppIcons.priority,
                size: 18.0 * ScaleSize.iconScaleFactor(context),
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
                textScaleFactor: ScaleSize.textScaleFactor(context),
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
                textScaleFactor: ScaleSize.textScaleFactor(context),
              ),
            ),
          ],
        );
    }
  }
}
