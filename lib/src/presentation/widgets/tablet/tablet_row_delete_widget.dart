import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/common/app_icons.dart';
import '../../../config/routes/dialogs.dart';
import '../../../utils/core/logging.dart';
import '../../../utils/core/scale_size.dart';
import '../../core/localization/app_localization.dart';
import '../../providers/current_todo_provider.dart';
import '../../providers/todos_manager.dart';

final Logging log = Logging('TabletRowDeleteWidget');

class TabletRowDeleteWidget extends ConsumerWidget {
  const TabletRowDeleteWidget({
    super.key,
  });

  // void _onGoBack(Todo? todo) {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Позволит в момент редактирования отловить изменения задачи
    /// в данном случае, интересен факт выгрузки на сервер
    ///
    final todo = ref.watch(choiseTodoProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 22.0, left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              if (todo?.changed != null) {
                final bool confirmed =
                    await Dialogs.showConfirmCloseCountDialog(context) ?? false;
                if (confirmed) {
                  ref.watch(todosManagerProvider).deleteTodo(todo: todo!);
                  ref.watch(editTodoProvider.notifier).state = false;
                  ref.watch(choiseTodoProvider.notifier).state = null;
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      AppIcons.delete,
                      color: todo?.changed == null
                          ? Theme.of(context).colorScheme.outlineVariant
                          : Theme.of(context).colorScheme.onSecondary,
                      size: 21.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        AppLocalization.of(context).get('delete'),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            height: 20 / 16,
                            fontFamily: 'Roboto',
                            color: todo?.changed == null
                                ? Theme.of(context).colorScheme.outlineVariant
                                : Theme.of(context).colorScheme.onSecondary),
                        textScaleFactor: ScaleSize.textScaleFactor(context),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: todo!.upload
                ? const Icon(
                    Icons.cloud_done_outlined,
                    size: 26.0,
                  )
                : const Icon(
                    Icons.cloud_off_outlined,
                    size: 26.0,
                  ),
          ),
        ],
      ),
    );
  }
}
