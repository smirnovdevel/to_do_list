import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/common/app_icons.dart';
import '../../../utils/core/scale_size.dart';
import '../../core/localization/app_localization.dart';
import '../../providers/done_provider.dart';

class MobileHeaderTodoWidget extends ConsumerWidget {
  const MobileHeaderTodoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(countDone);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final FlexibleSpaceBarSettings? settings = context
          .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
      if (settings == null) return const SizedBox();
      final double deltaExtent = settings.maxExtent - settings.minExtent;
      final double translation =
          (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
              .clamp(0.0, 1.0);
      final double start = max(0.0, 1.0 - 146 / deltaExtent);
      const double end = 1.0;
      final double currentValue =
          1.0 - Interval(start, end).transform(translation);

      return Padding(
        padding: EdgeInsets.only(
          left: 16 + 44 * currentValue,
          right: 19 + 6 * currentValue,
          bottom: 16 + 10 * currentValue,
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  AppLocalization.of(context).get('my_todo'),
                  style: TextStyle(
                      fontSize: 20 + 12 * currentValue,
                      fontWeight: FontWeight.w500),
                  textScaleFactor: ScaleSize.textScaleFactor(context),
                ),
                if (count == 0)
                  Container()
                else
                  Text(
                    '${AppLocalization.of(context).get('ready')} - $count',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(fontSize: 16 * currentValue),
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                  ),
              ],
            ),
            if (count == 0) Container() else const Spacer(),
            if (count == 0)
              Container()
            else
              GestureDetector(
                onTap: () {
                  if (ref.read(todosFilter) == TodosFilter.all) {
                    ref.read(todosFilter.notifier).state = TodosFilter.active;
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
                      weight: ref.watch(todosFilter) == TodosFilter.active
                          ? 18
                          : 22,
                      size: 20,
                    )),
              ),
          ],
        ),
      );
    });
  }
}
