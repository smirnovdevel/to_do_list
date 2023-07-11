import 'package:flutter/material.dart';

import '../../config/common/app_icons.dart';
import '../../domain/models/todo.dart';
import '../localization/app_localization.dart';

class HintPopupMenuWidget extends StatelessWidget {
  const HintPopupMenuWidget({super.key, required this.value});

  final Priority value;
  @override
  Widget build(BuildContext context) {
    switch (value) {
      case Priority.low:
        return Text(
          AppLocalization.of(context).get('low'),
          style: Theme.of(context).textTheme.titleSmall,
        );
      case Priority.basic:
        return Text(
          AppLocalization.of(context).get('basic'),
          style: Theme.of(context).textTheme.titleSmall,
        );
      default:
        return Row(
          children: [
            Icon(
              AppIcons.priority,
              size: 16.0,
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            Text(AppLocalization.of(context).get('important'),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    )),
          ],
        );
    }
  }
}
