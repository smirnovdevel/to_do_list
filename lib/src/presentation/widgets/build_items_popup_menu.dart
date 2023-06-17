import 'package:flutter/material.dart';

import '../../config/common/app_icons.dart';

List<PopupMenuEntry<int>> buildItemsPopupMenu(BuildContext context) {
  List<PopupMenuEntry<int>> list = [];
  list.add(PopupMenuItem<int>(
      value: 0,
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        'Нет',
        style: Theme.of(context).textTheme.bodyMedium,
      )));
  list.add(PopupMenuItem<int>(
      value: 1,
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        'Низкий',
        style: Theme.of(context).textTheme.bodyMedium,
      )));
  list.add(
    PopupMenuItem<int>(
      value: 2,
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
            Text('Высокий',
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
