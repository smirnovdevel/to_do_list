import 'package:logger/logger.dart';

/// Уровни детализации
/// verbose
/// debug
/// info
/// warning
/// error
/// wtf
///

class CustomPrinter extends LogPrinter {
  final String className;
  CustomPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];
    final message = event.message;
    return [color!('$emoji $className: $message')];
  }
}

// ignore: prefer_function_declarations_over_variables
final logger = (Type type) => Logger(
      // уровень логгирования - всё
      level: Level.verbose,
      printer: CustomPrinter(type.toString()),
    );
