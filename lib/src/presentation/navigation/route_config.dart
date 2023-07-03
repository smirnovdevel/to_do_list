class TodosRouteConfig {
  String? uuid;

  bool get isTodoScreen => uuid != null;

  bool get isRoot => !isTodoScreen;

  TodosRouteConfig(this.uuid);

  TodosRouteConfig.root() : uuid = null;

  TodosRouteConfig.todo(this.uuid);
}
