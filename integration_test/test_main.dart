import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/app.dart';

import '../test/data/locator_test.dart' as locator;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await locator.initializeDependencies();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
