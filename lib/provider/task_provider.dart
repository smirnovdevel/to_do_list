import 'package:flutter/material.dart';

import '../core/logging.dart';

final log = logger(TaskProvider);

class TaskProvider extends ChangeNotifier {
  bool visibleCompltedTask = true;
  bool get visible => visibleCompltedTask;

  void changeVisible() {
    visibleCompltedTask = !visibleCompltedTask;
    log.d('change visible to $visibleCompltedTask');
    notifyListeners();
  }
}
