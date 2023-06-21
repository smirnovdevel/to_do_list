import 'package:flutter/material.dart';

import '../../presentation/localization/app_localization.dart';

abstract class Dialogs {
  const Dialogs._();

  static Future<bool?> showConfirmCloseCountDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      routeSettings: const RouteSettings(
        name: '/alert_confirm_delete_task',
      ),
      barrierDismissible: false,
      builder: (BuildContext context) => const ConfirmCloseCountDialog(),
    );
  }
}

class ConfirmCloseCountDialog extends StatelessWidget {
  const ConfirmCloseCountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalization.of(context).get('confirm_delete')),
      actions: [
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            AppLocalization.of(context).get('no').toUpperCase(),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            AppLocalization.of(context).get('yes').toUpperCase(),
            style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
        ),
      ],
    );
  }
}
