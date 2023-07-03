import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/core/logging.dart';
import '../provider/todo_provider.dart';
import '../screens/main_screen.dart';
import '../screens/todo_screen.dart';
import 'route_config.dart';

final Logging log = Logging('TodosRouterDelegate');

/// NavigatorState – модель, которая определяет состояние навигации, мы ее создаем сами
/// ChangeNotifier – помогает оповещать об изменениях подписчиков, заодно реализует необходимые методы для RouterDelegate: addListener, removerListener
/// PopNavigatorRouterDelegateMixin – помогает управлять возвращением назад, в том числе системным, заодно реализуеи необходимые методы
class TodosRouterDelegate extends RouterDelegate<TodosRouteConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TodosRouteConfig> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  TodosRouterDelegate(this.ref) : navigatorKey = GlobalKey<NavigatorState>();

  String? _uuid;
  final Ref ref;

  @override
  TodosRouteConfig get currentConfiguration {
    if (_uuid != null) {
      return TodosRouteConfig.todo(_uuid);
    }
    return TodosRouteConfig.root();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(
          key: ValueKey('MainScreen'),
          child: MainScreen(),
        ),
        if (_uuid != null)
          MaterialPage(
            key: ValueKey(_uuid!),
            child: TodoScreen(
              uuid: _uuid!,
            ),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (_uuid != null) {
          _uuid = null;
          notifyListeners();
          return true;
        }

        _uuid = null;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(TodosRouteConfig configuration) async {
    if (configuration.isTodoScreen) {
      _uuid = configuration.uuid;
      ref.read(todoProvider(_uuid!));
    } else {
      _uuid = null;
    }

    notifyListeners();
  }

  void pop() {
    log.info('Pop');
    _uuid = null;
    notifyListeners();
  }

  void push(String uuid) {
    log.info('Push');
    _uuid = uuid;
    ref.read(todoProvider(_uuid!));
    notifyListeners();
  }
}
