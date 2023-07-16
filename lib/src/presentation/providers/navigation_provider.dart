import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../navigation/todos_router_delegate.dart';

Provider<TodosRouterDelegate> navigationProvider = Provider(
  (ref) => TodosRouterDelegate(ref),
);
