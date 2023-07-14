import 'package:flutter/material.dart';

import '../../../config/common/app_icons.dart';
import '../../../utils/core/scale_size.dart';
import '../../core/localization/app_localization.dart';

class MobileButtonNewTodoWidget extends StatelessWidget {
  const MobileButtonNewTodoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.only(left: 19.0, bottom: 15.0),
        child: Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Icon(AppIcons.add,
                      color: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalization.of(context).get('new'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
