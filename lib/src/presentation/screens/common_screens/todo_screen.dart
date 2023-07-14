import 'package:flutter/material.dart';

import '../../../utils/core/logging.dart';
import '../../widgets/common_widgets/responsive_widget.dart';
import '../mobile/todo_details_screen.dart';

final Logging log = Logging('MainScreen');

class TodoScreen extends StatelessWidget {
  const TodoScreen({
    super.key,
    required this.uuid,
  });
  final String uuid;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    log.debug('Screen resolution height: ${size.height} width: ${size.width}');
    return ResponsiveWidget(
      mobileWidget: TodoDetailsScreen(uuid: uuid),
      tabletWidget: TodoDetailsScreen(uuid: uuid),
      desktopWidget: TodoDetailsScreen(uuid: uuid),
    );
  }
}
