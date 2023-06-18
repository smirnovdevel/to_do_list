import 'package:flutter/material.dart';

import '../../config/common/app_icons.dart';
import '../../domain/models/task.dart';

///
/// Widget title item task in list
///
class TitletWidget extends StatelessWidget {
  const TitletWidget({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    ///
    /// Disactivate task icon
    ///
    if (task.done) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              task.title,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 3,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 19.0,
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
    /// Task low priority icon
    ///
    switch (task.priority) {
      case 1:
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
              child: Text(task.title,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        );

      ///
      /// Task high priority icon
      ///
      case 2:
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
                task.title,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        );

      ///
      /// Task without priority icon
      ///
      default:
        return Row(
          children: [
            Flexible(
              child: Text(
                task.title,
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
