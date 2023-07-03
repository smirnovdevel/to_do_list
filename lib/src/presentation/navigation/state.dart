import 'package:flutter/foundation.dart';

class NavigationState with ChangeNotifier {
  bool _isWelcome;
  String? _todoId;
  NavigationState(this._isWelcome, this._todoId);
  bool get isWelcome => _isWelcome;
  String? get todoId => _todoId;
  set isWelcome(bool val) {
    _isWelcome = val;
    notifyListeners();
  }

  set todoId(String? val) {
    _todoId = val;
    notifyListeners();
  }

  @override
  String toString() => "Welcome: $_isWelcome, todo: $_todoId";
}

class NavigationStateDTO {
  bool welcome;
  String? todoId;
  NavigationStateDTO(this.welcome, this.todoId);
  NavigationStateDTO.welcome()
      : welcome = true,
        todoId = null;
  NavigationStateDTO.todos()
      : welcome = false,
        todoId = null;
  NavigationStateDTO.todo(String id)
      : welcome = false,
        todoId = id;
}
