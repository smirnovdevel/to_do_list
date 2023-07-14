import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/core/logging.dart';
import '../../provider/todos_manager.dart';
import '../../provider/todos_provider.dart';
import '../../widgets/desktop/desktop_details_todo_widget.dart';
import '../../widgets/desktop/desktop_list_todo_widget.dart';
import '../../widgets/common_widgets/loading_indicator.dart';

final Logging log = Logging('DesktopMainScreen');

class TabletMainScreen extends ConsumerWidget {
  const TabletMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log.info('Is Desktop');
    final todos = ref.watch(todosStateProvider);
    if (todos == null) {
      ref.watch(todosManagerProvider).init();
    }
    return todos == null
        ? const LoadingIndicator()
        : const Row(
            children: [
              Expanded(
                flex: 3,
                child: DesktopListTodoWidget(),
              ),
              Expanded(
                flex: 2,
                child: DesktopDetailsTodoWidget(),
              ),
            ],
          );
  }
}
