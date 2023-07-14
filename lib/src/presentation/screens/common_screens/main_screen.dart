import 'package:flutter/material.dart';

import '../../../utils/core/logging.dart';
import '../desktop/desktop_main_screen.dart';
import '../mobile/mobile_main_screen.dart';
import '../../widgets/common_widgets/responsive_widget.dart';
import '../tablet/tablet_main_screen.dart';

final Logging log = Logging('MainScreen');

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    log.debug('Screen resolution height: ${size.height} width: ${size.width}');
    return const ResponsiveWidget(
      mobileWidget: MobileMainScreen(),
      tabletWidget: TabletMainScreen(),
      desktopWidget: DesktopMainScreen(),
    );
  }
}
