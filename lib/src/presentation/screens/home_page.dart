import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../domain/models/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/list_tasks_widget.dart';
import '../widgets/loading_indicator.dart';

final Logger log = Logger('HomePage');
List<TaskModel> tasks = [];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TaskBloc()..add(TasksInit()),
      child: BlocConsumer<TaskBloc, TaskState>(
        listener: (BuildContext context, TaskState state) {
          if (state is TaskDeleted) {
            log.info('listener delete task id: ${state.task.uuid}');
            tasks.removeWhere((TaskModel task) => task.uuid == state.task.uuid);
            context.read<TaskBloc>().add(TasksUpdating());
          }
        },
        builder: (BuildContext context, TaskState state) {
          if (state is TasksEmpty) {
            log.info('builder - task state empty');
            return loadingIndicator();
          } else if (state is TasksLoading) {
            log.info('builder - task state loading');
            return loadingIndicator();
          } else if (state is TasksLoaded) {
            log.info('builder - task state loaded');
            tasks.clear();
            tasks.addAll(state.tasksList);
            context.read<TaskBloc>().add(TasksUpdating());
            return loadingIndicator();
          } else if (state is TasksUpdated) {
            log.info('builder - task state updated');
            return ListTasksWidget(tasks: tasks);
          } else if (state is TasksError) {
            log.info('builder - task state error');
            return Text(
              state.message,
              style: const TextStyle(color: Colors.white, fontSize: 25),
            );
          } else {
            return const Center(
              child: Text('что-то пошло не так'),
            );
          }
        },
      ),
    );
  }
}
