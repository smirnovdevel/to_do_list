import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/common/app_icons.dart';
import 'package:to_do_list/provider/task_provider.dart';

class HeaderTaskWidget extends StatelessWidget {
  const HeaderTaskWidget({super.key, required this.count});

  final int count;
  @override
  Widget build(BuildContext context) {
    TaskProvider provider = Provider.of<TaskProvider>(context);
    return LayoutBuilder(builder: (context, constraints) {
      final settings = context
          .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
      if (settings == null) return const SizedBox();
      final deltaExtent = settings.maxExtent - settings.minExtent;
      final translation =
          (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
              .clamp(0.0, 1.0);
      final start = max(0.0, 1.0 - 146 / deltaExtent);
      const end = 1.0;
      final currentValue = 1.0 - Interval(start, end).transform(translation);

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
                  'Мои дела',
                  style: TextStyle(
                      fontSize: 20 + 12 * currentValue,
                      fontWeight: FontWeight.w500),
                ),
                count == 0
                    ? Container()
                    : Text(
                        'Выполнено - $count',
                        // style: TextStyle(fontSize: 16 * currentValue),
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontSize: 16 * currentValue),
                      ),
              ],
            ),
            count == 0 ? Container() : const Spacer(),
            count == 0
                ? Container()
                : GestureDetector(
                    onTap: () {
                      provider.changeVisible();
                    },
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          provider.visible
                              ? AppIcons.visibility
                              : AppIcons.visibilityOff,
                          weight: provider.visible ? 18 : 22,
                          size: 20,
                        )),
                  ),
          ],
        ),
      );
    });
  }
}
