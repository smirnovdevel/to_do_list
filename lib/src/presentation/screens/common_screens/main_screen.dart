import 'package:flutter/material.dart';

import '../desktop/desktop_main_screen.dart';
import '../mobile/mobile_main_screen.dart';
import '../../widgets/common_widgets/responsive_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveWidget(
      mobileWidget: MobileMainScreen(),
      tabletWidget: MobileMainScreen(),
      desktopWidget: DesktopMainScreen(),
    );
  }
}
