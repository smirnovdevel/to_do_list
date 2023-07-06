class TodosRouteConfig {
  final bool? _new;
  final bool? _unknown;

  String? uuid;

  bool get isNew => _new == true;

  bool get isTodoScreen => uuid != null && !isNew && !isUnknown;

  bool get isRoot => !isTodoScreen && !isNew && !isUnknown;

  bool get isUnknown => _unknown == true;

  TodosRouteConfig.root()
      : _new = false,
        _unknown = false,
        uuid = null;

  TodosRouteConfig.create(this.uuid)
      : _new = true,
        _unknown = false;

  TodosRouteConfig.todo(this.uuid)
      : _new = false,
        _unknown = false;

  TodosRouteConfig.unknown()
      : _unknown = true,
        _new = false,
        uuid = null;
}
