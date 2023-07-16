import 'package:flutter/material.dart';

import '../common/app_color.dart';

class ConfigTheme {
  static ThemeData replaceRedColor(
      {required Color? color, required ThemeData theme}) {
    /// У темной и светлой темы родные красные цвета разные
    ///
    late Color replaceColor;
    if (theme.brightness == Brightness.dark) {
      // темная тема
      replaceColor = color ?? AppColor.darkRed;
    } else {
      // светлая тема
      replaceColor = color ?? AppColor.lightRed;
    }

    return theme.copyWith(
        colorScheme: ColorScheme(
            brightness: theme.colorScheme.brightness,
            primary: theme.colorScheme.primary,
            onPrimary: theme.colorScheme.onPrimary,
            secondary: replaceColor,
            onSecondary: theme.colorScheme.onSecondary,
            error: replaceColor,
            onError: theme.colorScheme.onError,
            secondaryContainer: replaceColor,
            onSecondaryContainer: replaceColor.withOpacity(0.16),
            background: theme.colorScheme.background,
            onBackground: theme.colorScheme.onBackground,
            surface: theme.colorScheme.surface,
            onSurface: theme.colorScheme.onSurface));
  }
}
