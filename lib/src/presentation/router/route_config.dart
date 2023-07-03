import '../../domain/models/todo.dart';

class RouteConfig {
  final Todo? todo;
  final bool unknown;

  RouteConfig.home()
      : todo = null,
        unknown = false;

  RouteConfig.edit({this.todo}) : unknown = false;

  RouteConfig.unknown()
      : todo = null,
        unknown = true;

  bool get isHomePage => todo == null && unknown == false;

  bool get isEditPage => todo != null || unknown == true;

  bool get isUnknown => unknown == true;
}
