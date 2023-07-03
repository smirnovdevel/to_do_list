import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../navigation/router.dart';

ChangeNotifierProvider<TodosRouterDelegate> navigationProvider =
    ChangeNotifierProvider(
  (ref) => TodosRouterDelegate(ref),
);
