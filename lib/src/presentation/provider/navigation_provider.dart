import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../navigation/router_delegate.dart';

ChangeNotifierProvider<TodosRouterDelegate> navigationProvider =
    ChangeNotifierProvider(
  (ref) => TodosRouterDelegate(ref),
);
