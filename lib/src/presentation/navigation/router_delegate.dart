import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/core/logging.dart';
import '../provider/todo_provider.dart';
import '../screens/main_screen.dart';
import '../screens/todo_screen.dart';
import '../screens/unknown_screen.dart';
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

  TodosRouteConfig? state;
  final Ref ref;

  @override
  TodosRouteConfig get currentConfiguration {
    return state ?? TodosRouteConfig.root();
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
        if (state?.isNew == true)
          MaterialPage(
            child: TodoScreen(
              uuid: state!.uuid!,
            ),
          ),
        if (state?.uuid != null)
          MaterialPage(
            key: ValueKey(state!.uuid!),
            child: TodoScreen(
              uuid: state!.uuid!,
            ),
          ),
        if (state?.isUnknown == true)
          const MaterialPage(
            child: UnknownScreen(name: ''),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        state = TodosRouteConfig.root();

        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(TodosRouteConfig configuration) async {
    state = configuration;
    notifyListeners();
  }

  void pop() {
    log.info('Pop');
    state = TodosRouteConfig.root();
    notifyListeners();
  }

  void showTodo(String uuid) {
    log.info('Push');
    ref.read(todoProvider(uuid));
    state = TodosRouteConfig.todo(uuid);
    notifyListeners();
  }
}
