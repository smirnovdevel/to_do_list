import 'package:flutter/material.dart';

import '../../../utils/core/scale_size.dart';
import '../../core/localization/app_localization.dart';

class DesktopUnknownScreen extends StatelessWidget {
  const DesktopUnknownScreen({
    required this.name,
    super.key,
  });

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              '${AppLocalization.of(context).get('page_not_found')}\n$name',
              style: Theme.of(context).textTheme.headlineMedium,
              textScaleFactor: ScaleSize.textScaleFactor(context),
            ),
          ),
        ),
      ),
    );
  }
}
