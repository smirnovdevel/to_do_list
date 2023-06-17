import 'package:flutter/material.dart';

abstract class Dialogs {
  const Dialogs._();

  static Future<bool?> showConfirmCloseCountDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      routeSettings: const RouteSettings(
        name: '/alert_confirm_delete_task',
      ),
      barrierDismissible: false,
      builder: (context) => const ConfirmCloseCountDialog(),
    );
  }
}

class ConfirmCloseCountDialog extends StatelessWidget {
  const ConfirmCloseCountDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Вы уверены, что хотите удалить эту задачу?'),
      actions: [
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'НЕТ',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'ДА',
            style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
        ),
      ],
    );
  }
}
