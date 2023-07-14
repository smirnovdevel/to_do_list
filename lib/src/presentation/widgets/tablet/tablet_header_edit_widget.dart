import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/core/logging.dart';
import '../../../utils/core/scale_size.dart';
import '../../provider/current_todo_provider.dart';

final Logging log = Logging('TabletHeaderDetailsWidget');

class TabletHeaderEditWidget extends ConsumerWidget {
  const TabletHeaderEditWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(currentTodoProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 16, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(),
          if (todo == null)
            Container()
          else
            GestureDetector(
              onTap: () {
                log.debug('Edit todo close');
                ref.read(editTodoProvider.notifier).state = false;
                if (ref.read(currentTodoProvider)?.changed == null) {
                  ref.read(currentTodoProvider.notifier).state = null;
                }
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.close,
                  size: 24 * ScaleSize.iconScaleFactor(context),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
