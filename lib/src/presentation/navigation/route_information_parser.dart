import 'package:flutter/material.dart';

import '../../domain/models/routes.dart';
import 'navigation_state.dart';

/// URL -> NavigationState
class TodoRouteInformationParser
    extends RouteInformationParser<NavigationState> {
  @override
  Future<NavigationState> parseRouteInformation(
      RouteInformation routeInformation) async {
    final location = routeInformation.uri.path;

    final uri = Uri.parse(location);

    if (uri.pathSegments.isEmpty) {
      return NavigationState.root();
    }

    if (uri.pathSegments.length == 2) {
      final uuid = uri.pathSegments[1];

      if (uri.pathSegments[0] == Routes.todo) {
        return NavigationState.todo(uuid);
      }

      return NavigationState.root();
    }

    return NavigationState.root();
  }

  /// NavigationState -> URL
  @override
  RouteInformation? restoreRouteInformation(NavigationState configuration) {
    if (configuration.isTodoScreen) {
      return RouteInformation(
          uri: Uri.parse('${Routes.todo}/${configuration.uuid}'));
    }

    return RouteInformation(uri: Uri.parse(Routes.root));
  }
}
