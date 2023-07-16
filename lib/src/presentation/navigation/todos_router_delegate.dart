import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../utils/core/logging.dart';
import '../providers/analitics_provider.dart';
import '../screens/common_screens/main_screen.dart';
import '../providers/todo_provider.dart';
import '../screens/common_screens/unknown_screen.dart';
import '../screens/mobile/mobile_edit_screen.dart';
import '../widgets/common_widgets/flavor_banner.dart';
import 'route_config.dart';

final Logging log = Logging('TodosRouterDelegate');

/// NavigatorState – модель, которая определяет состояние навигации, мы ее создаем сами
/// ChangeNotifier – помогает оповещать об изменениях подписчиков, заодно реализует необходимые методы для RouterDelegate: addListener, removerListener
/// PopNavigatorRouterDelegateMixin – помогает управлять возвращением назад, в том числе системным, заодно реализуеи необходимые методы
class TodosRouterDelegate extends RouterDelegate<TodosRouteConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TodosRouteConfig> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  TodosRouterDelegate(this._ref) : navigatorKey = GlobalKey<NavigatorState>();

  TodosRouteConfig? _state;
  final Ref _ref;

  @override
  TodosRouteConfig get currentConfiguration {
    return _state ?? TodosRouteConfig.root();
  }

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: Navigator(
        key: navigatorKey,
        pages: [
          const MaterialPage(
            key: ValueKey('MainScreen'),
            child: MainScreen(),
          ),
          if (_state?.isNew == true)
            MaterialPage(
              child: MobileEditScreen(
                uuid: _state!.uuid!,
              ),
            ),
          if (_state?.uuid != null)
            MaterialPage(
              key: ValueKey(_state!.uuid!),
              child: MobileEditScreen(
                uuid: _state!.uuid!,
              ),
            ),
          if (_state?.isUnknown == true)
            const MaterialPage(
              child: UnknownScreen(name: ''),
            ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          _state = TodosRouteConfig.root();

          notifyListeners();
          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(TodosRouteConfig configuration) async {
    _state = configuration;
    notifyListeners();
  }

  void pop() {
    _ref
        .read(analyticsProvider)
        .logEvent(name: 'Pop', parameters: {'source': 'TodosRouterDelegate'});
    log.debug('Pop');
    _state = TodosRouteConfig.root();
    notifyListeners();
  }

  void showTodo(String? uuid) {
    _ref.read(analyticsProvider).logEvent(
        name: 'showTodo', parameters: {'source': 'TodosRouterDelegate'});
    log.debug('Push');
    // ignore: prefer_const_constructors
    uuid ??= Uuid().v1();
    _ref.read(todoProvider(uuid));
    _state = TodosRouteConfig.todo(uuid);
    notifyListeners();
  }
}
