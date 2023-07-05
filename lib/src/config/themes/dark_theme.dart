import 'package:flutter/material.dart';
import '../common/app_color.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Roboto',
  scaffoldBackgroundColor: AppColor.darkBackPrimary,
  disabledColor: const Color(0x26000000),
  shadowColor: Colors.black.withOpacity(0.12),
  primaryColor: AppColor.white,
  indicatorColor: Colors.black.withOpacity(0.06),
  snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  //
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: AppColor.darkBackSecondary,
    onPrimary: Colors.white,
    secondary: const Color(0xFF34C759),
    onSecondary: AppColor.darkRed,
    error: const Color(0xFFFF3B30),
    onError: Colors.white,
    background: Colors.white,
    onBackground: const Color(0x4D000000),
    // surface: const Color(0xFF007AFF),
    surface: Colors.white,
    onSurface: Colors.black.withOpacity(0.6),
    // checkbox
    primaryContainer: AppColor.darkGreyLight,
    secondaryContainer: AppColor.darkRed,
    onSecondaryContainer: AppColor.darkRed.withOpacity(0.16),
    tertiaryContainer: AppColor.darkGreen,
    // неактиная корзина - Удалить
    outlineVariant: AppColor.white.withOpacity(0.15),
    // иконка информации
    inverseSurface: AppColor.white.withOpacity(0.3),
  ),
  cardTheme: const CardTheme(
    color: AppColor.darkBackSecondary,
  ),
  iconTheme: const IconThemeData(
    color: AppColor.darkBlue,
  ),
  //
  dividerTheme: const DividerThemeData(color: AppColor.lightGrey),
  primaryIconTheme: IconThemeData(
    color: Colors.black.withOpacity(0.3),
  ),
  // switch
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return AppColor.darkBlue;
      }
      if (states.contains(MaterialState.disabled)) {
        return AppColor.black;
      }
      return AppColor.black;
    }),
    trackColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return AppColor.darkBlue.withOpacity(0.3);
      }
      if (states.contains(MaterialState.disabled)) {
        return AppColor.white;
      }
      return AppColor.darkGreyLight;
    }),
  ),
  //
  popupMenuTheme: const PopupMenuThemeData(
    color: AppColor.darkBackElevated,
  ),
  //
  textTheme: TextTheme(
    titleLarge: const TextStyle(color: AppColor.white),
    // кнопка СОХРАНИТЬ
    titleMedium: const TextStyle(
      fontSize: 14.0,
      height: 24 / 14,
      fontWeight: FontWeight.w500,
      color: AppColor.darkBlue,
    ),
    bodyMedium: const TextStyle(
      fontSize: 16.0,
      height: 20 / 16,
      fontWeight: FontWeight.w400,
      color: AppColor.white,
    ),
    // серые подписи
    titleSmall: TextStyle(
      fontSize: 14.0,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
      color: AppColor.darkLabelTertiary.withOpacity(0.4),
    ),
    labelSmall: TextStyle(
      fontSize: 16.0,
      height: 20 / 16,
      fontWeight: FontWeight.w400,
      color: AppColor.white.withOpacity(0.4),
    ),
  ),
  useMaterial3: true,
);
