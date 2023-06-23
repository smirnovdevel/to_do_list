import 'package:flutter/widgets.dart';

import '../../utils/core/logging.dart';

final Logging log = Logging('NavigationLogger');

class NavigationLogger extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    log.info('didPush: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    log.info('didPop: ${route.settings.name}');
  }

  @override
  void didStopUserGesture() {}

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {}

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {}

  @override
  void didRemove(Route route, Route? previousRoute) {}
}
