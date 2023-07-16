import 'package:flutter/material.dart';

import '../../../config/common/app_icons.dart';
import '../../../utils/core/scale_size.dart';

class TabletSwipeActionRightWidget extends StatelessWidget {
  const TabletSwipeActionRightWidget({
    super.key,
    required this.padding,
  });

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        color: const Color(0xFF34C759),
        child: Padding(
          padding: EdgeInsets.only(left: 27.0 + padding),
          child: Icon(
            AppIcons.check,
            color: Colors.white,
            size: 18 * ScaleSize.iconScaleFactor(context),
          ),
        ),
      ),
    );
  }
}
