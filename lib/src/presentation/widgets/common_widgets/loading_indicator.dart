import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onSecondary,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }
}
