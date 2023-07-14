import 'package:flutter/material.dart';

import '../../../../flavors.dart';

class FlavorBanner extends StatelessWidget {
  const FlavorBanner({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    switch (F.appFlavor) {
      case Flavor.dev:
        return Banner(
          location: BannerLocation.topEnd,
          message: F.name.toUpperCase(),
          color: Colors.blue.withOpacity(0.6),
          textStyle: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 12.0, letterSpacing: 3.0),
          textDirection: TextDirection.ltr,
          child: child,
        );
      case Flavor.prod:
        return Banner(
          location: BannerLocation.topEnd,
          message: F.name.toUpperCase(),
          color: Colors.green.withOpacity(0.6),
          textStyle: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 12.0, letterSpacing: 3.0),
          textDirection: TextDirection.ltr,
          child: child,
        );
      default:
        return child ?? const SizedBox();
    }
  }
}
