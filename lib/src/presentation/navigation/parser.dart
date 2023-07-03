import 'package:flutter/widgets.dart';

import 'paths.dart';
import 'state.dart';

//Transform state <-> URL
class TodosRouteInformationParser
    extends RouteInformationParser<NavigationStateDTO> {
  @override
  Future<NavigationStateDTO> parseRouteInformation(
      RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location ?? '');
    if (uri.pathSegments.isEmpty) {
      return Future.value(NavigationStateDTO.welcome());
    }
    switch (uri.pathSegments[0]) {
      case Paths.todos:
        return Future.value(NavigationStateDTO.todos());
      case Paths.todo:
        return Future.value(NavigationStateDTO.todo(uri.pathSegments[1]));
      default:
        return Future.value(NavigationStateDTO.welcome());
    }
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationStateDTO configuration) {
    if (configuration.welcome) {
      return const RouteInformation(location: Paths.welcome);
    }
    if (configuration.todoId == null) {
      return const RouteInformation(location: "/${Paths.todos}");
    }
    return RouteInformation(location: "/${Paths.todo}/${configuration.todoId}");
  }
}
