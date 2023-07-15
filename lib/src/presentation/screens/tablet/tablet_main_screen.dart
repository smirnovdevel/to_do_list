import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/core/logging.dart';
import '../../provider/todos_manager.dart';
import '../../provider/todos_provider.dart';
import '../../widgets/tablet/tablet_list_todo_widget.dart';
import '../../widgets/common_widgets/loading_indicator.dart';
import '../../widgets/tablet/tablet_switcher_widget.dart';

final Logging log = Logging('TabletMainScreen');

class TabletMainScreen extends ConsumerStatefulWidget {
  const TabletMainScreen({super.key});

  @override
  ConsumerState<TabletMainScreen> createState() => _TabletMainScreenState();
}

class _TabletMainScreenState extends ConsumerState<TabletMainScreen> {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    log.info('Is Tablet');
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
                child: TabletListTodoWidget(),
              ),
              Expanded(
                flex: 2,
                child: TabletSwitcherWidget(),
              ),
            ],
          );
  }
}
