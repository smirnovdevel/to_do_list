import 'dart:io';

import 'package:flutter/material.dart';
import 'app.dart';
import 'core/error/http_overrides.dart';
import 'core/logging.dart';
import 'di.dart' as di;

Future<void> main() async {
  //инициализация зависимостей
  await di.initializeDependencies();

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
