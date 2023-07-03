class NavigationState {
  String? uuid;

  bool get isTodoScreen => uuid != null;

  bool get isRoot => !isTodoScreen;

  NavigationState(this.uuid);

  NavigationState.root() : uuid = null;

  NavigationState.todo(this.uuid);
}
