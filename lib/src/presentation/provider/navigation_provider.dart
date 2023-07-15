import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../navigation/router_delegate.dart';

Provider<TodosRouterDelegate> navigationProvider = Provider(
  (ref) => TodosRouterDelegate(ref),
);
