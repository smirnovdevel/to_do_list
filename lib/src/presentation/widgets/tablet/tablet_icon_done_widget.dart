import 'package:flutter/material.dart';

import '../../../config/common/app_icons.dart';
import '../../../domain/models/todo.dart';
import '../../../utils/core/scale_size.dart';

class TabletIconDoneTodoWidget extends StatelessWidget {
  const TabletIconDoneTodoWidget({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    if (todo.done) {
      return Padding(
        padding: const EdgeInsets.only(top: 2.0, left: 10.0, right: 14.0),
        child: Icon(
          AppIcons.checked,
          color: Theme.of(context).colorScheme.tertiaryContainer,
          size: 18.0 * ScaleSize.iconScaleFactor(context),
        ),
      );
    } else if (todo.importance == Priority.important) {
      return Padding(
        padding: const EdgeInsets.only(top: 2.0, left: 10.0, right: 14.0),
        child: Container(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          child: Icon(
            AppIcons.unchecked,
            color: Theme.of(context).colorScheme.secondaryContainer,
            size: 18.0 * ScaleSize.iconScaleFactor(context),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 2.0, left: 10.0, right: 14.0),
        child: Icon(
          AppIcons.unchecked,
          color: Theme.of(context).colorScheme.primaryContainer,
          size: 18.0 * ScaleSize.iconScaleFactor(context),
        ),
      );
    }
  }
}
