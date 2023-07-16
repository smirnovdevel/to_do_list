import 'package:flutter/material.dart';

import '../../../utils/core/logging.dart';
import '../../widgets/common_widgets/responsive_widget.dart';
import '../desktop/desktop_unknown_screen.dart';
import '../mobile/mobile_unknown_screen.dart';

final Logging log = Logging('UnknownScreen');

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({
    required this.name,
    super.key,
  });

  final String? name;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobileWidget: MobileUnknownScreen(
        name: name,
      ),
      tabletWidget: MobileUnknownScreen(name: name),
      desktopWidget: DesktopUnknownScreen(name: name),
    );
  }
}
