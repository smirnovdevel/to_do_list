import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/common/app_icons.dart';
import '../../../utils/core/scale_size.dart';
import '../../core/localization/app_localization.dart';
import '../../providers/current_todo_provider.dart';
import '../../providers/done_provider.dart';

class TabletHeaderListWidget extends ConsumerWidget {
  const TabletHeaderListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(countDone);
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 16, right: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            AppLocalization.of(context).get('my_todo'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            textScaleFactor: ScaleSize.textScaleFactor(context),
          ),
          const SizedBox(
            width: 20.0,
          ),
          if (count == 0)
            Container()
          else
            Text(
              '${AppLocalization.of(context).get('ready')} - $count',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(fontSize: 16),
              textScaleFactor: ScaleSize.textScaleFactor(context),
            ),
          if (count == 0) Container() else const Spacer(),
          if (count == 0)
            Container()
          else
            GestureDetector(
              onTap: () {
                if (ref.read(todosFilter) == TodosFilter.all) {
                  ref.read(todosFilter.notifier).state = TodosFilter.active;
                  if (ref.read(choiseTodoProvider)?.done == true) {
                    ref.read(choiseTodoProvider.notifier).state = null;
                    ref.read(editTodoProvider.notifier).state = false;
                  }
                } else {
                  ref.read(todosFilter.notifier).state = TodosFilter.all;
                }
              },
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    ref.watch(todosFilter) == TodosFilter.active
                        ? AppIcons.visibilityOff
                        : AppIcons.visibility,
                    weight:
                        ref.watch(todosFilter) == TodosFilter.active ? 18 : 22,
                    size: 18 * ScaleSize.iconScaleFactor(context),
                  )),
            ),
        ],
      ),
    );
  }
}
