import 'dart:io';

import 'package:flutter/material.dart';

import 'app.dart';
import 'src/locator.dart' as locator;
import 'src/utils/core/logging.dart';
import 'src/utils/error/http_overrides.dart';

Future<void> main() async {
  //инициализация зависимостей
  await locator.initializeDependencies();

  //инициализируем задержку при запуске приложения
  await initialization(null);

  HttpOverrides.global = MyHttpOverrides();

  initLogger();

  runApp(const App());
}

// задержка при запуске приложения в секундах
Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 1));
}
