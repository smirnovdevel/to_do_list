import 'package:flutter/material.dart';

import '../../config/common/app_icons.dart';

class SwipeActionLeftWidget extends StatelessWidget {
  const SwipeActionLeftWidget({
    super.key,
    required this.padding,
  });

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: const EdgeInsets.only(left: 27.0),
      color: const Color(0XFFFF3B30),
      child: Padding(
        padding: EdgeInsets.only(right: 27.0 + padding),
        child: const Icon(
          AppIcons.delete,
          color: Colors.white,
          size: 18.0,
        ),
      ),
    );
  }
}
