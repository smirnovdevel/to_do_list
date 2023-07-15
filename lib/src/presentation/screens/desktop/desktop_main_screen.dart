import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/common/app_screens.dart';
import '../../../utils/core/logging.dart';
import '../../provider/todos_manager.dart';
import '../../provider/todos_provider.dart';
import '../../widgets/tablet/tablet_list_todo_widget.dart';
import '../../widgets/common_widgets/loading_indicator.dart';
import '../../widgets/tablet/tablet_switcher_widget.dart';

final Logging log = Logging('DesktopMainScreen');

class DesktopMainScreen extends ConsumerWidget {
  const DesktopMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log.info('Is Desktop');
    final todos = ref.watch(todosStateProvider);
    if (todos == null) {
      ref.watch(todosManagerProvider).init();
    }
    return todos == null
        ? const LoadingIndicator()
        : const Scaffold(
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: AppScreens.desktopScreen / 2,
                  child: TabletListTodoWidget(),
                ),
                SizedBox(
                  width: AppScreens.desktopScreen / 2,
                  child: TabletSwitcherWidget(),
                ),
              ],
            ),
          );
  }
}
