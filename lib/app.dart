import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/bloc/task_bloc.dart';
import 'package:to_do_list/theme/dark_theme.dart';
import 'package:to_do_list/theme/light_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'routes/navigation.dart';
import 'routes/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => TaskBloc(),
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ru'),
          ],
          debugShowCheckedModeBanner: false,
          title: 'TODO лист',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          // navigator key
          navigatorKey: NavigationManager.instance.key,
          // named routes setup
          initialRoute: RouteNames.initialRoute,
          onGenerateRoute: RoutesBuilder.onGenerateRoute,
          onUnknownRoute: RoutesBuilder.onUnknownRoute,
          onGenerateInitialRoutes: RoutesBuilder.onGenerateInitialRoutes,
          // navigator observers
          navigatorObservers: NavigationManager.instance.observers,
        ),
      );
}
