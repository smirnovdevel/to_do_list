import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../config/common/app_icons.dart';
import '../../../domain/models/todo.dart';
import '../../../utils/core/scale_size.dart';
import '../../provider/current_todo_provider.dart';

Uuid uuid = const Uuid();

class TabletEmptyWidget extends ConsumerWidget {
  const TabletEmptyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Text(
          'Выберите ToDo из списка слева',
          textScaleFactor: ScaleSize.textScaleFactor(context),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0, right: 40.0),
        child: FloatingActionButton(
          onPressed: () {
            ref.read(currentTodoProvider.notifier).state = Todo(
              uuid: uuid.v1(),
              title: '',
              done: false,
              created: DateTime.now().toLocal().millisecondsSinceEpoch,
              changed: null,
              deviceId: null,
            );
            ref.read(editTodoProvider.notifier).state = true;
          },
          tooltip: 'Add_todo',
          backgroundColor: Theme.of(context).iconTheme.color,
          child: const Icon(
            AppIcons.add,
            color: Colors.white,
            weight: 8.0,
          ),
        ),
      ),
    );
  }
}
