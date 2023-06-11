import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/bloc/task_bloc.dart';
import 'package:to_do_list/models/task.dart';

import '../../common/app_icons.dart';
import '../../routes/navigation.dart';
import '../screens/edit_page.dart';
import 'item_list_tasks_widget.dart';
import 'loading_indicator.dart';
import 'task_item_list_widget.dart';

class TasksListWidget extends StatefulWidget {
  TasksListWidget({
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
        } else if (state is TasksUpdate) {
          if (tasks.isEmpty) {
            context.read<TaskBloc>().add(TasksInit());
          }
          return loadingIndicator();
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
                        return ItemListTasks(task: tasks[index]);
                      },
                      childCount: tasks.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _newTaskItemWidget(context),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showEditTaskPage(context);
            },
            tooltip: 'Add task',
            backgroundColor: Colors.blue,
            child: const Icon(AppIcons.add),
          ),
        );
      },
    );
  }

  GestureDetector _newTaskItemWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showEditTaskPage(context);
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 19.0, bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [_activityInvisible()],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleNewTask(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activityInvisible() {
    return const Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: Icon(AppIcons.add, color: Colors.white),
    );
  }

  Widget _titleNewTask() {
    return const Text(
      'Новое',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18.0,
        color: Colors.grey,
      ),
    );
  }

  Future<void> _showEditTaskPage(BuildContext context) async {
    int id = 0;
    if (tasks.isNotEmpty) {
      id = tasks.last.id + 1;
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPage(
          task: TaskModel(
            id: id,
            title: '',
            active: true,
            priority: 0,
            unlimited: true,
            deadline: DateTime.now(),
            delete: false,
          ),
          newTask: true,
        ),
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
