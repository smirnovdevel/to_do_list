import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/bloc/task_bloc.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/provider/task_provider.dart';

import '../../common/app_icons.dart';
import '../../core/logging.dart';
import '../../routes/navigation.dart';
import 'button_new_task_widget.dart';
import 'header_task_widget.dart';
import 'item_task_widget.dart';

final log = logger(ListTasksWidget);

class ListTasksWidget extends StatefulWidget {
  const ListTasksWidget({
    super.key,
    required this.tasks,
  });

  final List<TaskModel> tasks;

  @override
  State<ListTasksWidget> createState() => _ListTasksWidgetState();
}

class _ListTasksWidgetState extends State<ListTasksWidget> {
  final scrollController = ScrollController();

  bool visibleCloseTask = false;
  bool haveCloseTask = true;

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
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => TaskProvider(),
              )
            ],
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  shadowColor: Theme.of(context).colorScheme.shadow,
                  expandedHeight: 120.0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  flexibleSpace: HeaderTaskWidget(
                      count: widget.tasks.where((task) => !task.active).length),
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
                            itemCount: widget.tasks.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ItemTaskWidget(task: widget.tasks[index]);
                            },
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
    int id = 0;
    if (widget.tasks.isNotEmpty) {
      id = widget.tasks.last.id + 1;
    }

    final result = await NavigationManager.instance.openCreatePage(
      TaskModel(
        id: id,
        title: '',
        active: true,
        priority: 0,
        unlimited: true,
        deadline: DateTime.now(),
        delete: false,
      ),
    );

    if (!mounted) return;

    if (result != null) {
      // Is new task
      widget.tasks.add(result);
      context.read<TaskBloc>().add(UpdateTask(task: result));
    }
  }
}
