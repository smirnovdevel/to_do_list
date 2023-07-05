import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app.dart';
import 'src/locator.dart' as locator;
import 'src/utils/core/http_overrides.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase hosting app
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  //инициализация зависимостей
  await locator.initializeDependencies();

  //инициализируем задержку при запуске приложения
  await initialization(null);

  // Костыль для тестирования, если сертификат сервера просрочен
  HttpOverrides.global = MyHttpOverrides();

  // Remove the leading hash (#) from the URL of your Flutter web app
  setPathUrlStrategy();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

// задержка при запуске приложения в секундах
Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 1));
}
