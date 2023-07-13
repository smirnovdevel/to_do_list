import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_messages/riverpod_messages.dart';
import 'package:uuid/uuid.dart';

import '../../../config/common/app_icons.dart';
import '../../../utils/core/logging.dart';
import '../../provider/done_provider.dart';
import '../../provider/message_provider.dart';
import '../../provider/navigation_provider.dart';
import '../../provider/todos_manager.dart';
import '../button_new_todo_widget.dart';
import 'mobile_header_todo_widget.dart';
import 'mobile_card_todo_widget.dart';

final Logging log = Logging('MobileListTodoWidget');

class MobileListTodoWidget extends ConsumerStatefulWidget {
  const MobileListTodoWidget({
    super.key,
  });

  @override
  ConsumerState<MobileListTodoWidget> createState() => _ListTodoWidgetState();
}

class _ListTodoWidgetState extends ConsumerState<MobileListTodoWidget> {
  final ScrollController scrollController = ScrollController();

  Uuid uuid = const Uuid();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _updateTodoList() async {
    ref.watch(todosManagerProvider).init();
    await Future.delayed(const Duration(milliseconds: 300));
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
        child: SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  shadowColor: Theme.of(context).colorScheme.shadow,
                  expandedHeight: 120.0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  flexibleSpace: const MobileHeaderTodoWidget(),
                ),
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    await _updateTodoList();
                  },
                ),
                SliverToBoxAdapter(
                  child: Card(
                    margin: const EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                      child: Column(
                        children: [
                          RefreshIndicator(
                            // displacement: 250,
                            backgroundColor: Colors.yellow,
                            color: Colors.red,
                            strokeWidth: 2,
                            onRefresh: () async {
                              await _updateTodoList();
                            },
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              controller: scrollController,
                              shrinkWrap: true,
                              itemCount: todos.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MobileCardTodoWidget(todo: todos[index]);
                              },
                            ),
                          ),
                          // кнопка Новое внизу списка
                          GestureDetector(
                            onTap: () {
                              ref.read(navigationProvider).showTodo(uuid.v1());
                            },
                            child: const ButtonNewTodoWidget(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0, right: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            ref.read(navigationProvider).showTodo(uuid.v1());
          },
          tooltip: 'Add_todo',
          backgroundColor: Theme.of(context).iconTheme.color,
          child: const Icon(
            AppIcons.add,
            color: Colors.white,
            weight: 14.0,
          ),
        ),
      ),
    );
  }
}
