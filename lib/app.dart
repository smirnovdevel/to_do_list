import 'package:flutter/material.dart';

import 'src/config/routes/navigation.dart';
import 'src/config/routes/routes.dart';
import 'src/config/themes/dark_theme.dart';
import 'src/config/themes/light_theme.dart';
import 'src/presentation/localization/app_localization.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO лист',
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      supportedLocales: AppLocalization.supportedLocales,
      // navigator key
      navigatorKey: NavigationManager.instance.key,
      // named routes setup
      initialRoute: RouteNames.initialRoute,
      onGenerateRoute: RoutesBuilder.onGenerateRoute,
      onUnknownRoute: RoutesBuilder.onUnknownRoute,
      onGenerateInitialRoutes: RoutesBuilder.onGenerateInitialRoutes,
      // navigator observers
      navigatorObservers: NavigationManager.instance.observers,
    );
  }
}
