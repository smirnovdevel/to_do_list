import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';

final Logging log = Logging('currentTodoProvider');

// For desktop/landscape

final currentTodoProvider = StateProvider<Todo?>((_) => null);
