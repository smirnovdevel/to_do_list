import 'package:flutter/material.dart';

import '../../domain/models/todo.dart';
import '../screens/details_page.dart';
import '../screens/todos_page.dart';
import '../screens/unknown_page.dart';
import 'route_config.dart';

class TodoRouterDelegate extends RouterDelegate<RouteConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteConfig> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  Todo? _todo;
  bool show404 = false;

  TodoRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  // get current route based on the show404 flag and _selectedItem & _selectedRoute value
  @override
  RouteConfig get currentConfiguration {
    if (show404) {
      return RouteConfig.unknown();
    }

    if (_todo != null) {
      return RouteConfig.edit(todo: _todo);
    }

    return RouteConfig.home();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(
          key: ValueKey('HomePage'),
          child: TodosPage(),
        ),
        if (show404)
          const MaterialPage(
            key: ValueKey('UnknownPage'),
            child: UnknownPage(
              routeName: 'Unknown page',
            ),
          )
        else if (_todo != null)
          MaterialPage(
            key: const ValueKey('EditTaskPage'),
            child: DetailsPage(todo: _todo!),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _todo = null;
        show404 = false;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteConfig configuration) async {
    if (configuration.unknown) {
      _todo = null;
      show404 = true;
      return;
    }

    if (configuration.isEditPage) {
      _todo = configuration.todo;
    } else {
      _todo = null;
    }

    show404 = false;
  }

  void pop() {
    show404 = false;
    notifyListeners();
  }
}
