import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/config/themes/dark_theme.dart';
import 'src/config/themes/light_theme.dart';
import 'src/presentation/core/localization/app_localization.dart';
import 'src/presentation/navigation/route_information_parser.dart';
import 'src/presentation/providers/navigation_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

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
      routeInformationParser: TodoRouteInformationParser(ref),
    );
  }
}
