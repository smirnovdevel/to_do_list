import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalization {
  static const supportedLocales = [Locale('en'), Locale('ru')];
  static const _delegate = CustomLocalizationsDelegate();
  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    _delegate,
  ];

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  final Locale locale;
  final Map<String, String> translations;

  AppLocalization._(this.locale, this.translations);

  String get(String key) {
    final string = translations[key];
    if (string == null) {
      // ignore: avoid_print
      print('Translation missing: $key');
    }
    return string ?? 'unknown';
  }
}

class CustomLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalization> {
  const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalization.supportedLocales
      .map((e) => e.languageCode)
      .contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async {
    final content =
        await rootBundle.loadString('l10n/${locale.languageCode}.json');
    final map = jsonDecode(content) as Map<String, dynamic>;
    return AppLocalization._(
        locale, map.map((key, value) => MapEntry(key, value as String)));
  }

  @override
  bool shouldReload(CustomLocalizationsDelegate old) => false;
}
