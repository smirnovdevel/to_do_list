import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/config/routes/navigation.dart';
import 'src/config/routes/routes.dart';
import 'src/config/themes/dark_theme.dart';
import 'src/config/themes/light_theme.dart';
import 'src/presentation/bloc/task_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (BuildContext context) => TaskBloc(),
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
