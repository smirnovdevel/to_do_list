import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import '../../config/common/app_icons.dart';
import '../../config/routes/navigation.dart';
import '../../domain/models/todo.dart';
import '../provider/done_provider.dart';
import '../provider/todos_provider.dart';
import 'button_new_todo_widget.dart';
import 'header_todo_widget.dart';
import 'item_todo_widget.dart';
import 'loading_indicator.dart';

final Logger log = Logger('ListTodoWidget');

class ListTodoWidget extends ConsumerStatefulWidget {
  const ListTodoWidget({
    super.key,
  });

  @override
  ConsumerState<ListTodoWidget> createState() => _ListTodoWidgetState();
}

class _ListTodoWidgetState extends ConsumerState<ListTodoWidget> {
  final ScrollController scrollController = ScrollController();

  Uuid uuid = const Uuid();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _updateTodoList() async {
    ref.read(todosProvider.notifier).init();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void toTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(filteredTodos);
    final todosUpadated = ref.watch(todosUpdated);
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: todosUpadated
            ? loadingIndicator()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      shadowColor: Theme.of(context).colorScheme.shadow,
                      expandedHeight: 120.0,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      flexibleSpace: const HeaderTodoWidget(),
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
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ItemTodoWidget(todo: todos[index]);
                                  },
                                ),
                              ),
                              // кнопка Новое внизу списка
                              GestureDetector(
                                onTap: () {
                                  _onCreateTodo();
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0, right: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            _onCreateTodo();
          },
          tooltip: 'Add todo',
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

  Future<void> _onCreateTodo() async {
    final Todo? result = await NavigationManager.instance.openEditPage(
      Todo(
          uuid: uuid.v1(),
          title: '',
          done: false,
          priority: 0,
          deadline: null,
          deleted: false,
          created: DateTime.now(),
          changed: DateTime.now(),
          // TODO
          upload: true,
          autor: null),
    );

    if (!mounted) return;

    if (result != null) {
      // Is new todo
      ref.read(todosProvider.notifier).add(todo: result);
    }
  }
}
