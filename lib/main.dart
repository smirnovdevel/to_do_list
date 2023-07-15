import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'src/locator.dart' as locator;
import 'src/utils/core/http_overrides.dart';
import 'src/utils/core/logging.dart';

final Logging log = Logging('main');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase hosting app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log.debug('Firebase initialized');

  FlutterError.onError = (errorDetails) {
    log.warning('Caught error in FlutterError.onError');
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log.warning('Caught error in PlatformDispatcher.onError');
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    );
    return true;
  };
  log.debug('Crashlytics initialized');

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
