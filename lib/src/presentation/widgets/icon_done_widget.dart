import 'package:flutter/material.dart';

import '../../config/common/app_icons.dart';
import '../../domain/models/todo.dart';

class IconDoneTodoWidget extends StatelessWidget {
  const IconDoneTodoWidget({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    if (todo.done) {
      return Icon(
        AppIcons.checked,
        color: Theme.of(context).colorScheme.tertiaryContainer,
        weight: 18.0,
      );
    } else if (todo.importance == 'importance') {
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
