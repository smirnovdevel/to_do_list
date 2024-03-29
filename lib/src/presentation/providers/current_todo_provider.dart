import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';

final Logging log = Logging('currentTodoProvider');

// For desktop/landscape

final choiseTodoProvider = StateProvider<Todo?>((_) => null);

final editTodoProvider = StateProvider<bool>((_) => false);
