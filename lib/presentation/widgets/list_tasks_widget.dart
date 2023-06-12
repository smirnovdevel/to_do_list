import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/bloc/task_bloc.dart';
import 'package:to_do_list/models/task.dart';

import '../../common/app_icons.dart';
import '../../core/logging.dart';
import '../../routes/navigation.dart';
import 'button_new_task_widget.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              const SliverAppBar(
                pinned: true,
                expandedHeight: 124.0,
                titleSpacing: 0,
                backgroundColor: Color(0xFFF7F6F2),
                stretchTriggerOffset: 120,
                centerTitle: false,
                toolbarTextStyle: TextStyle(color: Colors.red),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Мои дела',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // SliverPersistentHeader(
              //   delegate: MyHeaderDelegate(),
              // ),
              // SliverToBoxAdapter(
              //   child: Card(
              //     child: ListView.builder(
              //       itemCount: tasks.length,
              //       itemBuilder: (BuildContext context, int index) {
              //         return ItemTaskWidget(task: tasks[index]);
              //       },
              //     ),
              //   ),
              // ),
              SliverAppBar(
                backgroundColor: const Color(0xFFF7F6F2),
                title: const Text('Мои дела'),
                elevation: 1,
                scrolledUnderElevation: 10,
                forceElevated: false,
                titleSpacing: 20,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ItemTaskWidget(task: widget.tasks[index]);
                  },
                  childCount: widget.tasks.length,
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

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const MyHeaderDelegate();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;

    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: 1 - progress,
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('11')],
            ),
          ),
          // AnimatedContainer(
          //   duration: const Duration(milliseconds: 100),
          //   padding: EdgeInsets.lerp(
          //     EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          //     EdgeInsets.only(bottom: 16),
          //     progress,
          //   ),
          //   alignment: Alignment.lerp(
          //     Alignment.bottomLeft,
          //     Alignment.bottomCenter,
          //     progress,
          //   ),
          //   child: Text(
          //     'Mountains',
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 20;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
