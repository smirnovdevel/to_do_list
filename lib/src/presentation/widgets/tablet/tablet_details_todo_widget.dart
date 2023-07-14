import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_messages/riverpod_messages.dart';
import 'package:uuid/uuid.dart';

import '../../../config/common/app_icons.dart';
import '../../../utils/core/scale_size.dart';
import '../../provider/current_todo_provider.dart';
import '../../provider/message_provider.dart';
import '../../provider/navigation_provider.dart';
import 'tablet_header_details_widget.dart';

Uuid uuid = const Uuid();

class TabletDetailsTodoWidget extends ConsumerWidget {
  const TabletDetailsTodoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(currentTodoProvider);
    return Scaffold(
      body: MessageOverlayListener(
        provider: messageStateProvider,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 24.0, right: 48.0),
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  shadowColor: Theme.of(context).colorScheme.shadow,
                  expandedHeight: 20.0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  flexibleSpace: const TabletHeaderDetailsWidget(),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: Text(
                          todo == null ? '' : todo.title,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
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
