import 'package:flutter/material.dart';

import '../../config/common/app_icons.dart';

class HintPopupMenuWidget extends StatelessWidget {
  const HintPopupMenuWidget({super.key, required this.value});

  final int value;
  @override
  Widget build(BuildContext context) {
    switch (value) {
      case 0:
        return Text(
          'Нет',
          style: Theme.of(context).textTheme.titleSmall,
        );
      case 1:
        return Text(
          'Низкий',
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
            Text('Высокий',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    )),
          ],
        );
    }
  }
}
