import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../config/common/app_icons.dart';
import '../../../domain/models/todo.dart';
import '../../../utils/core/logging.dart';
import '../../../utils/core/scale_size.dart';
import '../../provider/current_todo_provider.dart';
import 'tablet_header_view_widget.dart';

Uuid uuid = const Uuid();
final Logging log = Logging('TabletViewTodoWidget');

class TabletViewTodoWidget extends ConsumerWidget {
  const TabletViewTodoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(choiseTodoProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0, right: 48.0),
        child:
            CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          SliverAppBar(
            pinned: true,
            shadowColor: Theme.of(context).colorScheme.shadow,
            expandedHeight: 20.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: const TabletHeaderViewWidget(),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Text(
                    todo != null ? todo.title : '',
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0, right: 40.0),
        child: FloatingActionButton(
          onPressed: () {
            Todo todo = Todo(
              uuid: null,
              title: '',
              done: false,
              created: DateTime.now().toLocal().millisecondsSinceEpoch,
              changed: null,
              deviceId: null,
            );
            log.debug('Add todo ${todo.uuid}');
            ref.read(choiseTodoProvider.notifier).state = todo;
            ref.read(editTodoProvider.notifier).state = true;
          },
          tooltip: 'Add_todo',
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
