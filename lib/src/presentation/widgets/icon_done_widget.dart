import 'package:flutter/material.dart';

import '../../config/common/app_icons.dart';
import '../../domain/models/task.dart';

class IconDoneWidget extends StatelessWidget {
  const IconDoneWidget({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    if (task.done) {
      return Icon(
        AppIcons.checked,
        color: Theme.of(context).colorScheme.tertiaryContainer,
        weight: 18.0,
      );
    } else if (task.priority == 2) {
      return Container(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        child: Icon(
          AppIcons.unchecked,
          color: Theme.of(context).colorScheme.secondaryContainer,
          weight: 18.0,
        ),
      );
    } else {
      return Icon(
        AppIcons.unchecked,
        color: Theme.of(context).colorScheme.primaryContainer,
        weight: 18.0,
      );
    }
  }
}
