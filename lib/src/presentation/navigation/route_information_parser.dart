import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/routes.dart';
import '../../utils/core/logging.dart';
import '../provider/todos_provider.dart';
import 'route_config.dart';

final Logging log = Logging('RouteInformationParser');
Uuid newUuid = const Uuid();

/// URL -> NavigationState
class TodoRouteInformationParser
    extends RouteInformationParser<TodosRouteConfig> {
  TodoRouteInformationParser(this.ref);
  final WidgetRef ref;

  @override
  Future<TodosRouteConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    final location = routeInformation.uri.path;

    log.info(location);

    final uri = Uri.parse(location);
    log.info('path segment length: ${uri.pathSegments.length}');

    if (uri.pathSegments.isEmpty) {
      log.info('path emty, open root');
      return TodosRouteConfig.root();
    }

    if (uri.pathSegments.length == 2) {
      final uuid = uri.pathSegments[1];

      if (uri.pathSegments[0] == Routes.todo) {
        final todos = ref.watch(todosStateProvider);
        bool result = todos!.any((item) => item.uuid == uuid);
        if (result) {
          return TodosRouteConfig.todo(uuid);
        }
        log.info('todo uuid: $uuid not found');
      }

      return TodosRouteConfig.unknown();
    }

    if (uri.pathSegments.length == 1) {
      log.info('first segment: ${uri.pathSegments[0]}');
      if (uri.pathSegments[0] == Routes.create) {
        log.info('open new todo');
        return TodosRouteConfig.create(newUuid.v1());
      }

      return TodosRouteConfig.unknown();
    }

    return TodosRouteConfig.root();
  }

  /// NavigationState -> URL
  @override
  RouteInformation? restoreRouteInformation(TodosRouteConfig configuration) {
    if (configuration.isNew) {
      return RouteInformation(uri: Uri.parse('/${Routes.create}'));
    }

    if (configuration.isTodoScreen) {
      return RouteInformation(
          uri: Uri.parse('/${Routes.todo}/${configuration.uuid}'));
    }

    if (configuration.isUnknown) {
      return null;
    }

    return RouteInformation(uri: Uri.parse('/'));
  }
}
