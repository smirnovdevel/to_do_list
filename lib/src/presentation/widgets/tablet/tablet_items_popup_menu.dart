import 'package:flutter/material.dart';

import '../../../domain/models/todo.dart';
import '../../../utils/core/scale_size.dart';
import '../../core/localization/app_localization.dart';

List<PopupMenuEntry<Priority>> tabletItemsPopupMenu(BuildContext context) {
  List<PopupMenuEntry<Priority>> list = [];
  list.add(PopupMenuItem<Priority>(
      value: Priority.basic,
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        AppLocalization.of(context).get('basic'),
        style: Theme.of(context).textTheme.bodyMedium,
        textScaleFactor: ScaleSize.textScaleFactor(context),
      )));
  list.add(PopupMenuItem<Priority>(
      value: Priority.low,
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        AppLocalization.of(context).get('low'),
        style: Theme.of(context).textTheme.bodyMedium,
        textScaleFactor: ScaleSize.textScaleFactor(context),
      )));
  list.add(
    PopupMenuItem<Priority>(
      value: Priority.important,
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        AppLocalization.of(context).get('important'),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
        textScaleFactor: ScaleSize.textScaleFactor(context),
      ),
    ),
  );
  return list;
}
