import 'package:flutter/material.dart';

import '../../common/app_icons.dart';
import '../screens/edit_page.dart';

class RowDeleteItemWidget extends StatelessWidget {
  const RowDeleteItemWidget({
    super.key,
    required bool isCreate,
    required this.widget,
  }) : _isCreate = isCreate;

  final bool _isCreate;
  final EditPage widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0, left: 8.0),
      child: GestureDetector(
        onTap: () {
          if (!_isCreate) {
            widget.task.delete = true;
            Navigator.pop(context, widget.task);
          }
        },
        child: Row(
          children: [
            Icon(
              AppIcons.delete,
              color: _isCreate ? Colors.grey : Colors.red,
              size: 21.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Удалить',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                    color: _isCreate ? Colors.grey : Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}
