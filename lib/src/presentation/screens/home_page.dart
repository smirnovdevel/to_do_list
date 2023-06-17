import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:to_do_list/src/presentation/bloc/task_bloc.dart';

import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../../domain/models/task.dart';
import '../widgets/list_tasks_widget.dart';
import '../widgets/loading_indicator.dart';

final log = Logger('HomePage');
List<TaskModel> tasks = [];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc()..add(TasksInit()),
      child: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, TaskState state) {
          if (state is TasksEmpty) {
            log.info('listener task state empty');
            context.read<TaskBloc>().add(TasksInit());
          }
        },
        builder: (context, TaskState state) {
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
