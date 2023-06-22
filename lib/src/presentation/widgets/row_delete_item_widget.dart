import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/common/app_icons.dart';
import '../../config/routes/dialogs.dart';
import '../../config/routes/navigation.dart';
import '../../domain/models/todo.dart';
import '../localization/app_localization.dart';
import '../provider/done_provider.dart';
import '../provider/todos_provider.dart';

class RowDeleteItemWidget extends ConsumerStatefulWidget {
  const RowDeleteItemWidget({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  ConsumerState<RowDeleteItemWidget> createState() =>
      _RowDeleteItemWidgetState();
}

class _RowDeleteItemWidgetState extends ConsumerState<RowDeleteItemWidget> {
  void _onGoBack(Todo? todo) {
    NavigationManager.instance.pop(todo);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0, left: 8.0),
      child: GestureDetector(
        onTap: () async {
          final bool confirmed =
              await Dialogs.showConfirmCloseCountDialog(context) ?? false;
          if (confirmed) {
            ref.read(todosUpdated.notifier).state = false;
            ref.read(todosProvider.notifier).delete(todo: widget.todo);
            _onGoBack(null);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  AppIcons.delete,
                  color: widget.todo.uuid == null
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
                        color: widget.todo.uuid == null
                            ? Theme.of(context).colorScheme.outlineVariant
                            : Theme.of(context).colorScheme.onSecondary),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: widget.todo.upload
                  ? const Icon(
                      Icons.cloud_done_outlined,
                      size: 26.0,
                    )
                  : const Icon(
                      Icons.cloud_off_outlined,
                      size: 26.0,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
