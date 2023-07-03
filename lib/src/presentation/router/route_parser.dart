import 'package:flutter/cupertino.dart';

import 'route_config.dart';

class RouteParser extends RouteInformationParser<RouteConfig> {
  @override
  Future<RouteConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if (uri.pathSegments.isEmpty) {
      return RouteConfig.home();
    }

    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'todo') return RouteConfig.unknown();
      return RouteConfig.edit(todo: null);
    }

    return RouteConfig.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(RouteConfig configuration) {
    if (configuration.isHomePage) {
      return const RouteInformation(location: '/');
    }
    if (configuration.isEditPage) {
      return RouteInformation(location: '/task/${configuration.todo}');
    }
    return const RouteInformation(location: '/404');
  }
}
