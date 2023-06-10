import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/bloc/task_bloc.dart';
import 'package:to_do_list/models/task.dart';

import '../../common/app_icons.dart';
import '../screens/edit_page.dart';
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
        } else if (state is TasksLoaded) {
          tasks.clear();
          tasks.addAll(state.tasksList);
        } else if (state is TasksUpdate) {
          tasks.clear();
          context.read<TaskBloc>().add(TasksInit());
          return loadingIndicator();
        } else if (state is TasksError) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          );
        }

        return tasks.isNotEmpty
            ? Scaffold(
                body: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskItemListWidget(task: tasks[index]);
                    }),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _showEditTaskPage(context);
                  },
                  tooltip: 'Add task',
                  backgroundColor: Colors.blue,
                  child: const Icon(AppIcons.add),
                ),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Задач не найдено',
                    ),
                  ],
                ),
              );
      },
    );
  }

  Future<void> _showEditTaskPage(BuildContext context) async {
    int id = 0;
    if (tasks.isNotEmpty) {
      id = tasks.last.id! + 1;
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskPage(
          TaskModel(
            id: id,
            title: '',
            active: true,
            priority: 0,
            unlimited: true,
            deadline: DateTime.now(),
          ),
        ),
      ),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    if (result != null) {
      // Is new task

      setState(() {
        tasks.add(result);
      });

      context.read<TaskBloc>().add(UpdateTask(task: result));
      context.read<TaskBloc>().add(TasksInit());
    }
  }
}
