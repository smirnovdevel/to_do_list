import 'package:flutter/material.dart';

import '../../../config/common/app_icons.dart';
import '../../../domain/models/todo.dart';

class DesktopIconDoneTodoWidget extends StatelessWidget {
  const DesktopIconDoneTodoWidget({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    if (todo.done) {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 14.0),
        child: Icon(
          AppIcons.checked,
          color: Theme.of(context).colorScheme.tertiaryContainer,
          weight: 18.0,
        ),
      );
    } else if (todo.importance == Priority.important) {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 14.0),
        child: Container(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          child: Icon(
            AppIcons.unchecked,
            color: Theme.of(context).colorScheme.secondaryContainer,
            weight: 18.0,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 14.0),
        child: Icon(
          AppIcons.unchecked,
          color: Theme.of(context).colorScheme.primaryContainer,
          weight: 18.0,
        ),
      );
    }
  }
}
