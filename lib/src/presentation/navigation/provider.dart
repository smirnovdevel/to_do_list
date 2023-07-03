import 'dart:ui';

import 'package:flutter/material.dart';

import '../../utils/core/logging.dart';

final Logging log = Logging('DebugRouteInformationProvider');

class DebugRouteInformationProvider extends PlatformRouteInformationProvider {
  DebugRouteInformationProvider()
      : super(
            initialRouteInformation: RouteInformation(
                location: PlatformDispatcher.instance.defaultRouteName));

  @override
  Future<bool> didPushRoute(String route) {
    log.info('Platform reports $route');
    return super.didPushRoute(route);
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    log.info('Platform reports routeinformation: $routeInformation');
    return super.didPushRouteInformation(routeInformation);
  }
}
