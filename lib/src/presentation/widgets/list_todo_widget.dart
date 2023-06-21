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
import 'button_new_task_widget.dart';
import 'header_todo_widget.dart';
import 'item_todo_widget.dart';

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

  bool visibleDoneTodo = false;
  bool haveCloseTask = true;
  Uuid uuid = const Uuid();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _updateTaskList() async {
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
    return Scaffold(
      body: SafeArea(
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
                flexibleSpace: const HeaderTodoWidget(),
              ),
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await _updateTaskList();
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
                            await _updateTaskList();
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: todos.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ItemTodoWidget(todo: todos[index]);
                            },
                          ),
                        ),
                        // кнопка Новое внизу списка
                        GestureDetector(
                          onTap: () {
                            _onCreateTask();
                          },
                          child: const ButtonNewTaskWidget(),
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
            _onCreateTask();
          },
          tooltip: 'Add task',
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

  Future<void> _onCreateTask() async {
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
          upload: false,
          // TODO
          autor: 'global'),
    );

    if (!mounted) return;

    if (result != null) {
      // Is new task
      ref.read(todosProvider.notifier).add(result);
    }
  }
}
