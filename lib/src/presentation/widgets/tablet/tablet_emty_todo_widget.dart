import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../config/common/app_icons.dart';
import '../../../domain/models/todo.dart';
import '../../../utils/core/logging.dart';
import '../../../utils/core/scale_size.dart';
import '../../core/localization/app_localization.dart';
import '../../provider/current_todo_provider.dart';

final Logging log = Logging('TabletEmptyWidget');

class TabletEmptyWidget extends ConsumerWidget {
  const TabletEmptyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Text(
          AppLocalization.of(context).get('choise_todo'),
          textScaleFactor: ScaleSize.textScaleFactor(context),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0, right: 40.0),
        child: FloatingActionButton(
          onPressed: () {
            Todo todo = Todo(
              // ignore: prefer_const_constructors
              uuid: Uuid().v1(),
              title: '',
              done: false,
              created: DateTime.now().toLocal().millisecondsSinceEpoch,
              changed: null,
              deviceId: null,
            );
            log.debug('Add todo ${todo.uuid}');
            ref.read(choiseTodoProvider.notifier).state = todo;
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
