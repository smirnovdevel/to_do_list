import 'package:flutter/material.dart';

import '../../../config/common/app_icons.dart';
import '../../../utils/core/scale_size.dart';
import '../../core/localization/app_localization.dart';

class MobileButtonNewTodoWidget extends StatefulWidget {
  const MobileButtonNewTodoWidget({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<MobileButtonNewTodoWidget> createState() =>
      _MobileButtonNewTodoWidgetState();
}

class _MobileButtonNewTodoWidgetState extends State<MobileButtonNewTodoWidget> {
  bool animation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        animation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 400 + (widget.index * 100)),
      transform: Matrix4.translationValues(0, animation ? 0 : height, 0),
      padding: const EdgeInsets.only(bottom: 8.0),
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.only(left: 19.0, bottom: 15.0),
        child: Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Icon(AppIcons.add,
                      color: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalization.of(context).get('new'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
