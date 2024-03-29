import 'package:flutter/material.dart';
import '../common/app_color.dart';

ThemeData lightTheme(Color? replaceColor) => ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColor.lightBackPrimary,
      disabledColor: const Color(0x26000000),
      shadowColor: Colors.black.withOpacity(0.12),
      primaryColor: AppColor.black,
      indicatorColor: Colors.black.withOpacity(0.06),
      // Transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          // Set your transitions here:
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      //
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColor.white,
        onPrimary: Colors.white,
        secondary: const Color(0xFF34C759),
        onSecondary: replaceColor ?? AppColor.lightRed,
        error: replaceColor ?? const Color(0xFFFF3B30),
        onError: Colors.white,
        background: Colors.white,
        onBackground: const Color(0x4D000000),
        // surface: const Color(0xFF007AFF),
        surface: Colors.white,
        onSurface: Colors.black.withOpacity(0.6),
        // checkbox
        primaryContainer: AppColor.lightGreyLight,
        secondaryContainer: replaceColor ?? AppColor.lightRed,
        onSecondaryContainer:
            replaceColor ?? AppColor.lightRed.withOpacity(0.16),
        tertiaryContainer: AppColor.lightGreen,
        // неактиная корзина - Удалить
        outlineVariant: AppColor.white.withOpacity(0.15),
        // иконка информации
        inverseSurface: AppColor.lightLabelTertiary.withOpacity(0.3),
      ),
      cardTheme: const CardTheme(
        color: AppColor.white,
      ),
      iconTheme: const IconThemeData(
        color: AppColor.lightBlue,
      ),
      //
      dividerTheme: const DividerThemeData(color: AppColor.lightGrey),
      primaryIconTheme: IconThemeData(
        color: Colors.black.withOpacity(0.3),
      ),
      // switch
      switchTheme: SwitchThemeData(
        thumbColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return AppColor.lightBlue;
          }
          if (states.contains(MaterialState.disabled)) {
            return AppColor.white;
          }
          return AppColor.white;
        }),
        trackColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return AppColor.lightBlue.withOpacity(0.3);
          }
          if (states.contains(MaterialState.disabled)) {
            return AppColor.white;
          }
          return AppColor.lightGreyLight;
        }),
      ),
      //
      popupMenuTheme: const PopupMenuThemeData(
        color: AppColor.lightBackElevated,
      ),
      //
      textTheme: TextTheme(
        titleLarge: const TextStyle(color: AppColor.black),
        // кнопка СОХРАНИТЬ
        titleMedium: const TextStyle(
          fontSize: 14.0,
          height: 24 / 14,
          fontWeight: FontWeight.w500,
          color: AppColor.lightBlue,
        ),
        bodyMedium: const TextStyle(
          fontSize: 16.0,
          height: 20 / 16,
          fontWeight: FontWeight.w400,
          color: AppColor.black,
        ),
        // серые подписи
        titleSmall: TextStyle(
          fontSize: 14.0,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          color: AppColor.lightLabelTertiary.withOpacity(0.4),
        ),
        labelSmall: TextStyle(
          fontSize: 16.0,
          height: 20 / 16,
          fontWeight: FontWeight.w400,
          color: AppColor.black.withOpacity(0.3),
        ),
      ),
      useMaterial3: true,
    );
