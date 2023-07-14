import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../config/common/app_icons.dart';
import '../../../utils/core/scale_size.dart';
import '../../provider/current_todo_provider.dart';
import '../../provider/navigation_provider.dart';

Uuid uuid = const Uuid();

class DesktopDetailsTodoWidget extends ConsumerWidget {
  const DesktopDetailsTodoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(currentTodoProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 24.0, right: 48.0),
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              todo == null ? '' : todo.title,
              textScaleFactor: ScaleSize.textScaleFactor(context),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0, right: 40.0),
        child: FloatingActionButton(
          onPressed: () {
            ref.read(navigationProvider).showTodo(uuid.v1());
          },
          tooltip: 'Add_todo',
          // mini: true,
          backgroundColor: Theme.of(context).iconTheme.color,
          child: const Icon(
            AppIcons.add,
            color: Colors.white,
            weight: 8.0,
          ),
        ),
      ),
    );
  }
}
