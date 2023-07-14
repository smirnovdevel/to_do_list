import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/core/logging.dart';
import '../../provider/todos_manager.dart';
import '../../provider/todos_provider.dart';
import '../../widgets/mobile/mobile_list_todo_widget.dart';
import '../../widgets/common_widgets/loading_indicator.dart';

final Logging log = Logging('MobileMainScreen');

class MobileMainScreen extends ConsumerWidget {
  const MobileMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log.info('Is Mobile');
    final todos = ref.watch(todosStateProvider);
    if (todos == null) {
      ref.watch(todosManagerProvider).init();
    }
    return todos == null
        ? const LoadingIndicator()
        : const MobileListTodoWidget();
  }
}
