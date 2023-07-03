import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../navigation/delegate.dart';
import '../tracing/route_aware.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.cyan,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Welcome to bookshelf",
                style: TextStyle(fontSize: 42, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const Divider(),
              ElevatedButton(
                onPressed:
                    (Router.of(context).routerDelegate as TodosRouterDelegate)
                        .gotoBooks,
                // onPressed: context.read<BookshelfRouterDelegate>().gotoBooks,
                child: const Text(
                  "Go",
                  style: TextStyle(fontSize: 28),
                ),
              )
            ],
          ),
        ),
      );
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ObservedState<WelcomeScreen> {
  @override
  String get stateName => "WelcomePage";

  @override
  Widget build(BuildContext context) => kIsWeb || Platform.isAndroid
      ? const Scaffold(
          body: WelcomeWidget(),
        )
      : const CupertinoPageScaffold(child: WelcomeWidget());
}
