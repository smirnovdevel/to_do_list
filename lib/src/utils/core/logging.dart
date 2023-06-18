import 'dart:developer' as console;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

// console.log( "\u001b[1;31m Red message" );
// console.log( "\u001b[1;32m Green message" );
// console.log( "\u001b[1;33m Yellow message" );
// console.log( "\u001b[1;34m Blue message" );
// console.log( "\u001b[1;35m Purple message" );
// console.log( "\u001b[1;36m Cyan message" );

void initLogger() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord record) {
      switch (record.level) {
        case Level.FINE:
          {
            // green
            console.log(
                '\u001b[1;32m ${record.loggerName}:\u001b[1;32m ${record.message}');

            break;
          }
        case Level.INFO:
          {
            // blue
            console.log(
                '\u001b[1;32m ${record.loggerName}:\u001b[1;34m ${record.message}');
            break;
          }
        case Level.WARNING:
          {
            // red
            console.log(
                '\u001b[1;32m ${record.loggerName}:\u001b[1;31m ${record.message}');
            break;
          }
        default:
          {
            console.log('\u001b[1;32m ${record.loggerName}: record.message');
          }
      }
    });
  }
}
