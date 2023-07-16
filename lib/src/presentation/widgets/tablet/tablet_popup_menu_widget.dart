import 'package:flutter/material.dart';

import '../../../domain/models/todo.dart';
import '../../../utils/core/scale_size.dart';
import '../../core/localization/app_localization.dart';

class TabletPopupMenuWidget extends StatelessWidget {
  const TabletPopupMenuWidget({super.key, required this.value});

  final Priority value;
  @override
  Widget build(BuildContext context) {
    switch (value) {
      case Priority.low:
        return Text(
          AppLocalization.of(context).get('low'),
          style: Theme.of(context).textTheme.titleSmall,
          textScaleFactor: ScaleSize.textScaleFactor(context),
        );
      case Priority.basic:
        return Text(
          AppLocalization.of(context).get('basic'),
          style: Theme.of(context).textTheme.titleSmall,
          textScaleFactor: ScaleSize.textScaleFactor(context),
        );
      default:
        return Text(
          AppLocalization.of(context).get('important'),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
          textScaleFactor: ScaleSize.textScaleFactor(context),
        );
    }
  }
}
