import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('TaskProvider');

class TaskProvider extends ChangeNotifier {
  bool visibleCompltedTask = true;
  bool get visible => visibleCompltedTask;

  void changeVisible() {
    visibleCompltedTask = !visibleCompltedTask;
    log.fine('change visible to $visibleCompltedTask');
    notifyListeners();
  }
}
