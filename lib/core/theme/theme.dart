import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/palette.dart';

class AppTheme {
  static final fontTheme = ThemeData(
    fontFamily: 'Poppins',
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: AppPalette.textBodyColor),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppPalette.textTitleColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: AppPalette.textTitleColor,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppPalette.titleMediumColor,
      ),
    ),
  );

  static final _border = OutlineInputBorder(
    borderSide: BorderSide(color: AppPalette.textfieldColor),
    borderRadius: BorderRadius.circular(10),
  );

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPalette.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(12),
      filled: true,
      fillColor: AppPalette.textfieldColor,
      enabledBorder: _border,
      focusedBorder: _border,
      errorBorder: _border,
      focusedErrorBorder: _border,
    ),
  );

  static final navigatorTheme = ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}
