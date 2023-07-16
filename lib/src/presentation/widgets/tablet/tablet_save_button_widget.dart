import 'package:flutter/material.dart';

import '../../../utils/core/scale_size.dart';
import '../../core/localization/app_localization.dart';

class TabletSaveButtonWidget extends StatelessWidget {
  const TabletSaveButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save, size: 18.0 * ScaleSize.iconScaleFactor(context)),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                AppLocalization.of(context).get('save'),
                style: Theme.of(context).textTheme.bodyMedium,
                textScaleFactor: ScaleSize.textScaleFactor(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
