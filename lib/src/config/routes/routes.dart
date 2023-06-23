import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../../domain/models/todo.dart';
import '../../presentation/screens/edit_page.dart';
import '../../presentation/screens/home_page.dart';
import '../../presentation/screens/unknown_page.dart';

abstract class RouteNames {
  const RouteNames._();

  static const String initialRoute = home;

  static const String home = '/';
  static const String edit = '/edit';
}

abstract class RoutesBuilder {
  const RoutesBuilder._();

  static final Map<String, Widget Function(BuildContext p1)> routes =
      <String, Widget Function(BuildContext)>{
    RouteNames.home: (_) => const HomePage(),
    RouteNames.edit: (BuildContext context) => EditPage(
          todo: ModalRoute.of(context)?.settings.arguments as Todo,
        ),
  };

  static Route<Object?>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );

      case RouteNames.edit:
        return MaterialPageRoute<Todo?>(
          builder: (_) => EditPage(
            todo: settings.arguments as Todo,
          ),
          settings: settings,
        );
    }

    return null;
  }

  static Route<Object?>? onUnknownRoute<T>(RouteSettings settings) {
    return MaterialPageRoute<T>(
      builder: (BuildContext context) => UnknownPage(
        routeName: settings.name,
      ),
      settings: settings,
    );
  }

  static List<Route<Object?>> onGenerateInitialRoutes(String initialRoutes) {
    final List<Route> routes = <Route>[];

    if (initialRoutes.isEmpty || !initialRoutes.startsWith('/')) {
      developer.log(
          '\u001b[1;33m Routes: \u001b[1;34m invalid initialRoutes \u001b[0m ($initialRoutes)');
    } else {
      final List<String> names = initialRoutes.substring(1).split('/');
      for (final String name in names) {
        final Route<Object?>? route = onGenerateRoute(
          RouteSettings(name: '/$name'),
        );
        if (route != null) {
          routes.add(route);
        } else {
          routes.clear();
          break;
        }
      }
    }

    if (routes.isEmpty) {
      developer.log(
          '\u001b[1;33m Routes: \u001b[1;34m generated empty initial routes \u001b[0m ($initialRoutes)');
      routes.add(
        onGenerateRoute(const RouteSettings(name: RouteNames.home))!,
      );
    }

    return routes;
  }
}
