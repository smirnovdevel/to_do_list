import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../config/common/app_icons.dart';
import '../../config/routes/navigation.dart';
import '../../domain/models/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../provider/task_provider.dart';
import 'button_new_task_widget.dart';
import 'header_task_widget.dart';
import 'item_task_widget.dart';

final Logger log = Logger('ListTasksWidget');

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
  final ScrollController scrollController = ScrollController();

  bool visibleCloseTask = false;
  bool haveCloseTask = true;
  Uuid uuid = const Uuid();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _updateTaskList() async {
    context.read<TaskBloc>().add(TasksInit());
    await Future.delayed(const Duration());
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
                  flexibleSpace: Consumer<TaskProvider>(
                    builder: (BuildContext context, TaskProvider count,
                        Widget? child) {
                      return HeaderTaskWidget(
                          count: widget.tasks
                              .where((TaskModel task) =>
                                  task.done && !task.deleted)
                              .length);
                    },
                  ),
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
                              itemCount: widget.tasks.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ItemTaskWidget(
                                    task: widget.tasks[index]);
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
    final TaskModel? result = await NavigationManager.instance.openEditPage(
      TaskModel(
          id: null,
          uuid: null,
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
      result.uuid = uuid.v1();
      setState(() {
        widget.tasks.add(result);
      });

      context.read<TaskBloc>().add(SaveTask(task: result));
    }
  }
}
