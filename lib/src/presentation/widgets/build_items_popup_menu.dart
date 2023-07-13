import 'package:flutter/material.dart';

import '../../config/common/app_icons.dart';
import '../../domain/models/todo.dart';
import '../core/localization/app_localization.dart';

List<PopupMenuEntry<Priority>> buildItemsPopupMenu(BuildContext context) {
  List<PopupMenuEntry<Priority>> list = [];
  list.add(PopupMenuItem<Priority>(
      value: Priority.basic,
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        AppLocalization.of(context).get('basic'),
        style: Theme.of(context).textTheme.bodyMedium,
      )));
  list.add(PopupMenuItem<Priority>(
      value: Priority.low,
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        AppLocalization.of(context).get('low'),
        style: Theme.of(context).textTheme.bodyMedium,
      )));
  list.add(
    PopupMenuItem<Priority>(
      value: Priority.important,
      padding: const EdgeInsets.only(left: 16),
      child: SizedBox(
        width: 120,
        child: Row(
          children: [
            Icon(
              AppIcons.priority,
              size: 16.0,
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            Text(AppLocalization.of(context).get('important'),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    )),
          ],
        ),
      ),
    ),
  );
  return list;
}
