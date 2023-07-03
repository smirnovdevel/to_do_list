import 'package:flutter/widgets.dart';

import '../../utils/core/logging.dart';

final Logging log = Logging('TodosTransitionDelegate');

class TodosTransitionDelegate extends TransitionDelegate {
  @override
  Iterable<RouteTransitionRecord> resolve(
      {required List<RouteTransitionRecord> newPageRouteHistory,
      required Map<RouteTransitionRecord?, RouteTransitionRecord>
          locationToExitingPageRoute,
      required Map<RouteTransitionRecord?, List<RouteTransitionRecord>>
          pageRouteToPagelessRoutes}) {
    log.info('Calling transition delegate');
    List<RouteTransitionRecord> newHistory = [];
    for (var element in newPageRouteHistory) {
      if (element.isWaitingForEnteringDecision) {
        log.info('Element $element is marked for push');
        element.markForPush();
        newHistory.add(element);
      }
      if (element.isWaitingForExitingDecision) {
        log.info('Element $element is marked for pop');
        element.markForPop();
        newHistory.add(element);
      }
    }
    return newHistory;
  }
}
