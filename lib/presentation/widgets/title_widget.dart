import 'package:flutter/material.dart';

import '../../common/app_icons.dart';
import '../../models/task.dart';

class TitletWidget extends StatelessWidget {
  const TitletWidget({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
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
    switch (task.priority) {
      case 1:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              AppIcons.arrowDown,
              size: 14.0,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.5),
              child: Expanded(
                child: Text(task.title,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.clip,
                    maxLines: 3,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 19.0)),
              ),
            ),
          ],
        );
      case 2:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              AppIcons.priority,
              size: 16.0,
              color: Color(0xFFFF3B30),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(task.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 19.0)),
            ),
          ],
        );
      default:
        return Text(
          task.title,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 19.0,
            color: Colors.black,
          ),
        );
    }
  }
}
