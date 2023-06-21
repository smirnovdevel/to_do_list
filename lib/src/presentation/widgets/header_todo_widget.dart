import 'dart:math';

import 'package:flutter/material.dart';
import '../../config/common/app_icons.dart';

class HeaderTodoWidget extends StatelessWidget {
  const HeaderTodoWidget({super.key, required this.count});

  final int count;
  @override
  Widget build(BuildContext context) {
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
                  'Мои дела',
                  style: TextStyle(
                      fontSize: 20 + 12 * currentValue,
                      fontWeight: FontWeight.w500),
                ),
                if (count == 0)
                  Container()
                else
                  Text(
                    'Выполнено - $count',
                    // style: TextStyle(fontSize: 16 * currentValue),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(fontSize: 16 * currentValue),
                  ),
              ],
            ),
            if (count == 0) Container() else const Spacer(),
            if (count == 0)
              Container()
            else
              GestureDetector(
                onTap: () {
                  // provider.changeVisible();
                },
                child: const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      // provider.visible
                      //     ? AppIcons.visibilityOff
                      // :
                      AppIcons.visibility,
                      // weight: provider.visible ? 18 : 22,
                      weight: 22,
                      size: 20,
                    )),
              ),
          ],
        ),
      );
    });
  }
}
