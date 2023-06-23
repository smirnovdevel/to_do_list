import 'dart:developer' as console;

import 'package:flutter/foundation.dart';

// "\u001b[1;31m" Red
// "\u001b[1;32m" Green
// "\u001b[1;33m Yellow
// "\u001b[1;34m Blue
// "\u001b[1;35m Purple
// "\u001b[1;36m Cyan

class Logging {
  Logging(this.name);
  final String name;

  // 0 - all, 1 - info, 2 - warning
  final int level = 0;

  // green - blue
  void fine(String event) {
    if (kDebugMode) {
      console.log('\u001b[1;32m $name:\u001b[1;32m $event');
    }
  }

  // green - blue
  void info(String event) {
    if (kDebugMode) {
      console.log('\u001b[1;32m $name:\u001b[1;34m $event');
    }
  }

  // green - red
  void warning(String event) {
    if (kDebugMode) {
      console.log('\u001b[1;32m $name:\u001b[1;31m $event');
    }
  }
}
