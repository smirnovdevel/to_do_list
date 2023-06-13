import 'dart:math';

import 'package:flutter/material.dart';
import 'package:to_do_list/common/app_icons.dart';

class HeaderTaskWidget extends StatelessWidget {
  const HeaderTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                Opacity(
                  opacity: 0.3 * currentValue,
                  child: Text(
                    'Выполнено - 5',
                    style: TextStyle(fontSize: 16 * currentValue),
                  ),
                )
              ],
            ),
            const Spacer(),
            const Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  AppIcons.visibility,
                  size: 18,
                  // color: Theme.of(context).iconTheme.color,
                )),
          ],
        ),
      );
    });
  }
}
