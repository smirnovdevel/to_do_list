import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'src/locator.dart' as locator;
// import 'src/utils/error/http_overrides.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //инициализация зависимостей
  await locator.initializeDependencies();

  //инициализируем задержку при запуске приложения
  await initialization(null);

  // Костыль для тестирования, если сертификат сервера просрочен
  // HttpOverrides.global = MyHttpOverrides();

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
