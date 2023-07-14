import 'package:flutter/material.dart';

import '../../presentation/core/localization/app_localization.dart';
import '../../utils/core/scale_size.dart';

abstract class Dialogs {
  const Dialogs._();

  static Future<bool?> showConfirmCloseCountDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      routeSettings: const RouteSettings(
        name: '/alert_confirm_delete_todo',
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        AppLocalization.of(context).get('delete_title'),
        style: TextStyle(color: Theme.of(context).primaryColor),
        textScaleFactor: ScaleSize.textScaleFactor(context),
      ),
      content: Text(AppLocalization.of(context).get('delete_subtitle')),
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
            textScaleFactor: ScaleSize.textScaleFactor(context),
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
            textScaleFactor: ScaleSize.textScaleFactor(context),
          ),
        ),
      ],
    );
  }
}
