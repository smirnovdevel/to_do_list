import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_messages/riverpod_messages.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/core/logging.dart';
import '../../provider/done_provider.dart';
import '../../provider/message_provider.dart';
import '../../provider/navigation_provider.dart';
import '../button_new_todo_widget.dart';
import 'desktop_card_todo_widget.dart';
import 'desktop_header_todo_widget.dart';

final Logging log = Logging('DesktopListTodoWidget');

class DesktopListTodoWidget extends ConsumerStatefulWidget {
  const DesktopListTodoWidget({
    super.key,
  });

  @override
  ConsumerState<DesktopListTodoWidget> createState() => _ListTodoWidgetState();
}

class _ListTodoWidgetState extends ConsumerState<DesktopListTodoWidget> {
  final ScrollController scrollController = ScrollController();

  Uuid uuid = const Uuid();

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
            slivers: [
              SliverAppBar(
                pinned: true,
                shadowColor: Theme.of(context).colorScheme.shadow,
                expandedHeight: 20.0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                flexibleSpace: const DesktopHeaderTodoWidget(),
              ),
              SliverToBoxAdapter(
                child: Card(
                  margin: const EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                    child: Column(
                      children: [
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: todos.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DesktopCardTodoWidget(todo: todos[index]);
                          },
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
    );
  }
}
