import 'package:flutter/material.dart';

import '../../config/common/app_color.dart';
import '../localization/app_localization.dart';

mixin SelectDate on StatefulWidget {
  Future<DateTime?> selectDate(BuildContext context, DateTime deadline) async {
    final DateTime? pickedDate = await showDatePicker(
        locale: AppLocalization.of(context).locale,
        context: context,
        cancelText: AppLocalization.of(context).get('cancel'),
        confirmText: AppLocalization.of(context).get('done'),
        initialDate: deadline,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: AppColor.darkBlue,
                    primaryContainer: Colors.white,
                    secondaryContainer: Colors.white,
                    onSecondary: Colors.red,
                    surface: Theme.of(context).colorScheme.primary,
                    onSurface: Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFF252528)
                        : Colors.white,
                    onSurfaceVariant:
                        Theme.of(context).brightness == Brightness.light
                            ? const Color(0xFF252528)
                            : Colors.white,
                    secondary: Colors.blue,
                  ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).iconTheme.color,
                  // primary: Colors.green, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });
    if (pickedDate != null && pickedDate != deadline) {
      return pickedDate;
    }
    return null;
  }
}
