import 'package:flutter/material.dart';

import '../../config/common/app_icons.dart';

class SwipeActionRightWidget extends StatelessWidget {
  const SwipeActionRightWidget({
    super.key,
    required this.padding,
  });

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      color: const Color(0xFF34C759),
      child: Padding(
        padding: EdgeInsets.only(left: 27.42 + padding),
        child: const Icon(
          AppIcons.check,
          color: Colors.white,
          size: 17.58,
        ),
      ),
    );
  }
}
