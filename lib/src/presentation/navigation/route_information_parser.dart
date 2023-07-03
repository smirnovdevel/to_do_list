import 'package:flutter/material.dart';

import '../../domain/models/routes.dart';
import '../../utils/core/logging.dart';
import 'route_config.dart';

final Logging log = Logging('RouteInformationParser');

/// URL -> NavigationState
class TodoRouteInformationParser
    extends RouteInformationParser<TodosRouteConfig> {
  @override
  Future<TodosRouteConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    final location = routeInformation.uri.path;

    log.info(location);

    final uri = Uri.parse(location);

    if (uri.pathSegments.isEmpty) {
      return TodosRouteConfig.root();
    }

    if (uri.pathSegments.length == 2) {
      final uuid = uri.pathSegments[1];

      if (uri.pathSegments[0] == Routes.todo) {
        return TodosRouteConfig.todo(uuid);
      }

      return TodosRouteConfig.root();
    }

    return TodosRouteConfig.root();
  }

  /// NavigationState -> URL
  @override
  RouteInformation? restoreRouteInformation(TodosRouteConfig configuration) {
    if (configuration.isTodoScreen) {
      return RouteInformation(
          uri: Uri.parse('${Routes.todo}/${configuration.uuid}'));
    }

    return RouteInformation(uri: Uri.parse(Routes.root));
  }
}
