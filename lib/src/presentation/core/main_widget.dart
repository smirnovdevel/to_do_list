import 'package:flutter/material.dart';

import '../screens/desktop/desktop_main_screen.dart';
import '../screens/mobile/mobile_main_screen.dart';
import 'responsive_widget.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileLayout: MobileMainScreen(),
      desktopLayout: DesktopMainScreen(),
    );
  }
}
