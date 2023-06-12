import 'package:flutter/material.dart';

import '../../common/app_icons.dart';
import '../../models/task.dart';

class IconActivityWidget extends StatelessWidget {
  const IconActivityWidget({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    if (!task.active) {
      return const Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Icon(
          AppIcons.checked,
          color: Colors.green,
          weight: 18.0,
        ),
      );
    } else if (task.priority == 2) {
      return Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Container(
          color: Color(0x1FFF3B30),
          child: Icon(
            AppIcons.unchecked,
            color: Color(0xFFFF3B30),
            weight: 18.0,
          ),
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Icon(
          AppIcons.unchecked,
          color: Colors.grey,
          weight: 18.0,
        ),
      );
    }
  }
}
