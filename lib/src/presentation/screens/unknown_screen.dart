import 'package:flutter/material.dart';

import '../localization/app_localization.dart';

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({
    required this.name,
    super.key,
  });

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            '${AppLocalization.of(context).get('page_not_found')}\n$name',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
