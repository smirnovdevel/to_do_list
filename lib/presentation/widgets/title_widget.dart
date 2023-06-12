import 'package:flutter/material.dart';

import '../../common/app_icons.dart';
import '../../models/task.dart';

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
    if (!task.active) {
      return Text(
        task.title,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 19.0,
          color: Colors.grey,
          decoration: TextDecoration.lineThrough,
          decorationColor: Colors.grey,
          decorationStyle: TextDecorationStyle.solid,
        ),
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
              padding: EdgeInsets.only(top: 4.5),
              child: Icon(
                AppIcons.arrowDown,
                size: 16.0,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.5),
              child: Text(task.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 19.0)),
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
            const Padding(
              padding: EdgeInsets.only(top: 4.5),
              child: Icon(
                AppIcons.priority,
                size: 18.0,
                color: Color(0xFFFF3B30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(task.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 19.0)),
            ),
          ],
        );

      ///
      /// Task without priority icon
      ///
      default:
        return Row(
          children: [
            Text(
              task.title,
              softWrap: true,
              maxLines: 3,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 19.0,
                color: Colors.black,
              ),
            ),
          ],
        );
    }
  }
}
