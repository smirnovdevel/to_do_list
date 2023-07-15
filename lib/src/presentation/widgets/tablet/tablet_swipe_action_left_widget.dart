import 'package:flutter/material.dart';

import '../../../config/common/app_icons.dart';
import '../../../utils/core/scale_size.dart';

class TabletSwipeActionLeftWidget extends StatelessWidget {
  const TabletSwipeActionLeftWidget({
    super.key,
    required this.padding,
  });

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.only(
            left: 27.0, top: 12.0, bottom: 12.0, right: 12.0),
        color: const Color(0XFFFF3B30),
        child: Padding(
          padding: EdgeInsets.only(right: 27.0 + padding),
          child: Icon(
            AppIcons.delete,
            color: Colors.white,
            size: 18 * ScaleSize.iconScaleFactor(context),
          ),
        ),
      ),
    );
  }
}
