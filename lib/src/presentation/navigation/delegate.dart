import 'package:flutter/material.dart';

import '../../domain/models/todo.dart';
import '../screens/details_page.dart';
import '../screens/todos_page.dart';
import '../screens/welcome.dart';
import 'state.dart';
import 'transition.dart';

//Example of stacked router delegate (for simulating Navigator 1.0 behavior)
class StackedRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final List<Page> _pages = [];

  push(Page _page) {
    _pages.add(_page);
    notifyListeners();
  }

  pop() {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
      notifyListeners();
    }
  }

  replace(Page _page) {
    if (_pages.isEmpty) {
      _pages.add(_page);
    } else {
      _pages[_pages.length - 1] = _page;
    }
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _pages,
    );
  }

  @override
  get currentConfiguration => super.currentConfiguration;

  //внимание - не возвращать GlobalKey() из геттера, чтобы не получить пересоздание навигатора!
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    return Future.value();
  }
}

class CustomAnimationPage<T> extends MaterialPage<T> {
  const CustomAnimationPage({
    required Widget child,
    LocalKey? key,
    String? name,
    Object? arguments,
  }) : super(
          child: child,
          key: key,
          name: name,
          arguments: arguments,
        );

  @override
  Route<T> createRoute(BuildContext context) => PageRouteBuilder(
        transitionDuration: const Duration(seconds: 2),
        reverseTransitionDuration: const Duration(seconds: 2),
        settings: this,
        pageBuilder: (context, animation, secondAnimation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionsBuilder: (context, animation, secondAnimation, child) =>
            FractionalTranslation(
          translation: Offset(1 - animation.value, 1 - animation.value),
          child: child,
        ),
      );
}

class TodosRouterDelegate extends RouterDelegate<NavigationStateDTO>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationStateDTO> {
  NavigationState state = NavigationState(true, null);

  bool get isWelcome => state.isWelcome;

  bool get isTodosList => !state.isWelcome && state.todoId == null;

  bool get isTodoDetails => !state.isWelcome && state.todoId != null;

  void gotoBooks() {
    state
      ..isWelcome = false
      ..todoId = null;
    notifyListeners();
  }

  void gotoBook(String id) {
    state
      ..isWelcome = false
      ..todoId = id;
    notifyListeners();
  }

  TransitionDelegate delegate = TodosTransitionDelegate();

  @override
  Widget build(BuildContext context) => Navigator(
        onPopPage: (route, result) => route.didPop(result),
        key: navigatorKey,
        pages: [
          if (state.isWelcome)
            const CustomAnimationPage(
              child: WelcomeScreen(),
            ),
          if (!state.isWelcome)
            const CustomAnimationPage(
              child: TodosPage(),
            ),
          if (state.todoId != null)
            CustomAnimationPage(
              child: DetailsPage(
                  todo: Todo(
                      uuid: 'uuid',
                      title: 'title',
                      done: false,
                      priority: 0,
                      deadline: null,
                      deleted: false,
                      created: DateTime.now(),
                      changed: DateTime.now(),
                      upload: false,
                      autor: 'autor')),
            ),
        ],
      );

  @override
  NavigationStateDTO? get currentConfiguration {
    return NavigationStateDTO(state.isWelcome, state.todoId);
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey();

  @override
  Future<void> setNewRoutePath(NavigationStateDTO configuration) {
    state.todoId = configuration.todoId;
    state.isWelcome = configuration.welcome;
    return Future.value();
  }
}
