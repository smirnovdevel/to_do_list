import 'package:flutter/material.dart';

import 'src/config/themes/dark_theme.dart';
import 'src/config/themes/light_theme.dart';
import 'src/presentation/localization/app_localization.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TODO лист',
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      supportedLocales: AppLocalization.supportedLocales,
      // Navigator 2.0
      routerDelegate: TodosRouterDelegate(),
      routeInformationParser: TodosRouteInformationParser(),
      routeInformationProvider: DebugRouteInformationProvider(),
    );
  }
}
