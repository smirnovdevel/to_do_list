import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({
    required this.routeName,
    super.key,
  });

  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Page not found\n$routeName',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
