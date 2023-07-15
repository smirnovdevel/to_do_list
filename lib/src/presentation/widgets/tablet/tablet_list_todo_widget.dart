import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_messages/riverpod_messages.dart';

import '../../../domain/models/todo.dart';
import '../../../utils/core/logging.dart';
import '../../provider/current_todo_provider.dart';
import '../../provider/done_provider.dart';
import '../../provider/message_provider.dart';
import 'tablet_button_new_widget.dart';
import 'tablet_card_todo_widget.dart';
import 'tablet_header_list_widget.dart';

final Logging log = Logging('TabletListTodoWidget');

class TabletListTodoWidget extends ConsumerStatefulWidget {
  const TabletListTodoWidget({
    super.key,
  });

  @override
  ConsumerState<TabletListTodoWidget> createState() => _ListTodoWidgetState();
}

class _ListTodoWidgetState extends ConsumerState<TabletListTodoWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void toTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(filteredTodosProvider);
    return Scaffold(
      body: MessageOverlayListener(
        provider: messageStateProvider,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 24.0, right: 24.0, top: 8.0, bottom: 8.0),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                shadowColor: Theme.of(context).colorScheme.shadow,
                expandedHeight: 20.0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                flexibleSpace: const TabletHeaderListWidget(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                  child: Column(
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        controller: scrollController,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: todos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TabletCardTodoWidget(
                              todo: todos[index], index: index);
                        },
                      ),
                      // кнопка Новое внизу списка
                      GestureDetector(
                        onTap: () {
                          ref.read(choiseTodoProvider.notifier).state = Todo(
                            uuid: null,
                            title: '',
                            done: false,
                            created:
                                DateTime.now().toLocal().millisecondsSinceEpoch,
                            changed: null,
                            deviceId: null,
                          );
                          ref.read(editTodoProvider.notifier).state = true;
                        },
                        child: TabletButtonNewWidget(
                          index: todos.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
