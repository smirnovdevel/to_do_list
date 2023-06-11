import 'package:flutter/material.dart';
import 'package:to_do_list/models/task.dart';

import '../presentation/screens/edit_page.dart';
import '../presentation/screens/home_page.dart';
import '../presentation/screens/unknown_page.dart';

abstract class RouteNames {
  const RouteNames._();

  static const initialRoute = home;

  static const home = '/';
  static const edit = '/edit';
  static const create = '/create';
}

abstract class RoutesBuilder {
  const RoutesBuilder._();

  static final routes = <String, Widget Function(BuildContext)>{
    RouteNames.home: (_) => const HomePage(),
    RouteNames.edit: (context) => EditPage(
          task: ModalRoute.of(context)?.settings.arguments as TaskModel,
          isCreate: false,
        ),
    RouteNames.create: (context) => EditPage(
          task: ModalRoute.of(context)?.settings.arguments as TaskModel,
          isCreate: true,
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
        return MaterialPageRoute<TaskModel?>(
          builder: (_) => EditPage(
            task: settings.arguments as TaskModel,
            isCreate: false,
          ),
          settings: settings,
        );

      case RouteNames.create:
        return MaterialPageRoute<TaskModel?>(
          builder: (_) => EditPage(
            task: settings.arguments as TaskModel,
            isCreate: true,
          ),
          settings: settings,
        );
    }

    return null;
  }

  static Route<Object?>? onUnknownRoute<T>(RouteSettings settings) {
    return MaterialPageRoute<T>(
      builder: (context) => UnknownPage(
        routeName: settings.name,
      ),
      settings: settings,
    );
  }

  static List<Route<Object?>> onGenerateInitialRoutes(String initialRoutes) {
    final routes = <Route>[];

    if (initialRoutes.isEmpty || !initialRoutes.startsWith('/')) {
      print('invalid initialRoutes ($initialRoutes)');
    } else {
      final names = initialRoutes.substring(1).split('/');
      for (final name in names) {
        final route = onGenerateRoute(
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
      print('generated empty initial routes ($initialRoutes)');
      routes.add(
        onGenerateRoute(const RouteSettings(name: RouteNames.home))!,
      );
    }

    return routes;
  }
}
