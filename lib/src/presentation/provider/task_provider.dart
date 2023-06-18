import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger log = Logger('TaskProvider');

class TaskProvider extends ChangeNotifier {
  bool visibleCompltedTask = true;
  bool get visible => visibleCompltedTask;

  void changesStatusTask() {
    log.warning('change statys task');
    notifyListeners();
  }

  void changeVisible() {
    visibleCompltedTask = !visibleCompltedTask;
    log.fine('change visible to $visibleCompltedTask');
    notifyListeners();
  }
}
