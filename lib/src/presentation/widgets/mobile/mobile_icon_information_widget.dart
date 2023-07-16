import 'package:flutter/material.dart';

import '../../../config/common/app_icons.dart';

class MobileIconInformationWidget extends StatelessWidget {
  const MobileIconInformationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 16.0, top: 2.0),
      child: Icon(
        AppIcons.infoOutline,
        color: Theme.of(context).colorScheme.inverseSurface,
        weight: 20,
      ),
    );
  }
}
