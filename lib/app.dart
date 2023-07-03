import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/config/themes/dark_theme.dart';
import 'src/config/themes/light_theme.dart';
import 'src/presentation/localization/app_localization.dart';
import 'src/presentation/navigation/router.dart';
import 'src/presentation/provider/navigation_provider.dart';

class App extends ConsumerWidget {
  App({super.key});

  final _routerInformationParser = TodoRouteInformationParser();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TODO лист',
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      supportedLocales: AppLocalization.supportedLocales,
      // Navigator 2.0
      routerDelegate: ref.watch(navigationProvider),
      routeInformationParser: _routerInformationParser,
    );
  }
}
