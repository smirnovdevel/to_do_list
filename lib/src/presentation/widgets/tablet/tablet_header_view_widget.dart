import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/core/logging.dart';
import '../../../utils/core/scale_size.dart';
import '../../providers/current_todo_provider.dart';

final Logging log = Logging('TabletHeaderViewWidget');

class TabletHeaderViewWidget extends ConsumerWidget {
  const TabletHeaderViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 16, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(),
          GestureDetector(
            onTap: () {
              log.debug('Edit todo');
              ref.read(editTodoProvider.notifier).state = true;
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.edit,
                size: 22 * ScaleSize.iconScaleFactor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
