import 'package:flutter/material.dart';
import 'app.dart';
import 'di.dart' as di;

Future<void> main() async {
  //инициализация зависимостей
  await di.initializeDependencies();

  //инициализируем задержку при запуске приложения
  await initialization(null);

  runApp(const App());
}

// задержка при запуске приложения в секундах
Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 1));
}
