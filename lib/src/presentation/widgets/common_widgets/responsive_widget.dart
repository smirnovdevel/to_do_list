import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    super.key,
    required this.mobileWidget,
    required this.tabletWidget,
    required this.desktopWidget,
  });

  final Widget mobileWidget;
  final Widget tabletWidget;
  final Widget desktopWidget;

  static int tabletWidth = 900;
  static int desktopWidth = 1440;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= desktopWidth) {
          return desktopWidget;
        } else if (constraints.maxWidth < tabletWidth) {
          return mobileWidget;
        } else {
          return tabletWidget;
        }
      },
    );
  }
}
