import 'package:flutter/material.dart';
import '../../domain/models/task.dart';

import 'observer.dart';
import 'routes.dart';

class NavigationManager {
  NavigationManager._();

  static final NavigationManager instance = NavigationManager._();

  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  final List<NavigatorObserver> observers = <NavigatorObserver>[
    NavigationLogger(),
  ];

  NavigatorState get _navigator => key.currentState!;

  Future<TaskModel?> openEditPage(TaskModel task) {
    return _navigator.pushNamed<TaskModel?>(
      RouteNames.edit,
      arguments: task,
    );
  }

  void pop<T extends Object>([T? result]) {
    _navigator.pop(result);
  }

  void popToHome() {
    _navigator.popUntil(ModalRoute.withName(RouteNames.home));
  }
}
