import 'dart:developer' as console;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

// "\u001b[1;31m" Red
// "\u001b[1;32m" Green
// "\u001b[1;33m Yellow
// "\u001b[1;34m Blue
// "\u001b[1;35m Purple
// "\u001b[1;36m Cyan

Provider loggerProvider = Provider(
  (ref) => Logger('logger'),
);

void initLogger() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord record) {
      switch (record.level) {
        case Level.FINE:
          {
            // green - green
            console.log(
                '\u001b[1;32m ${record.loggerName}:\u001b[1;32m ${record.message}');

            break;
          }
        case Level.INFO:
          {
            // green - blue
            console.log(
                '\u001b[1;32m ${record.loggerName}:\u001b[1;34m ${record.message}');
            break;
          }
        case Level.WARNING:
          {
            // green - red
            console.log(
                '\u001b[1;32m ${record.loggerName}:\u001b[1;31m ${record.message}');
            break;
          }
        default:
          {
            console.log('${record.loggerName}: record.message');
          }
      }
    });
  }
}
