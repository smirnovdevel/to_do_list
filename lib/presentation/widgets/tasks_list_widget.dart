import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/bloc/task_bloc.dart';
import 'package:to_do_list/models/task.dart';

import '../../common/app_icons.dart';
import '../../routes/navigation.dart';
import 'button_new_task_widget.dart';
import 'item_task_widget.dart';
import 'loading_indicator.dart';

class TasksListWidget extends StatefulWidget {
  const TasksListWidget({
    super.key,
  });

  @override
  State<TasksListWidget> createState() => _TasksListWidgetState();
}

class _TasksListWidgetState extends State<TasksListWidget> {
  final scrollController = ScrollController();

  List<TaskModel> tasks = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, TaskState state) {
        if (state is TasksEmpty) {
          context.read<TaskBloc>().add(TasksInit());
          return loadingIndicator();
        } else if (state is TasksLoading) {
          return loadingIndicator();
        } else if (state is TasksLoaded && tasks.isEmpty) {
          tasks.addAll(state.tasksList);
        } else if (state is TasksError) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                      pinned: true,
                      expandedHeight: 150.0,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text('Available seats'),
                        background: Image.network(
                          'https://r-cf.bstatic.com/images/hotel/max1024x768/116/116281457.jpg',
                          fit: BoxFit.fitWidth,
                        ),
                      )),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return ItemTaskWidget(task: tasks[index]);
                      },
                      childCount: tasks.length,
                    ),
                  ),
                  // кнопка Новое внизу списка
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () {
                        _onCreateTask();
                      },
                      child: const ButtonNewTaskWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _onCreateTask();
            },
            tooltip: 'Add task',
            backgroundColor: Colors.blue,
            child: const Icon(AppIcons.add),
          ),
        );
      },
    );
  }

  Future<void> _onCreateTask() async {
    int id = 0;
    if (tasks.isNotEmpty) {
      id = tasks.last.id + 1;
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
      tasks.add(result);
      setState(() {});
      context.read<TaskBloc>().add(UpdateTask(task: result));
    }
  }
}
