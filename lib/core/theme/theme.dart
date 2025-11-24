import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';

class AppTheme {
  static final fontTheme = ThemeData(
    fontFamily: 'Poppins',
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: AppPallete.textBodyColor),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppPallete.textTitleColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: AppPallete.textTitleColor,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppPallete.titleMediumColor,
      ),
    ),
  );

  static final _border = OutlineInputBorder(
    borderSide: BorderSide(color: AppPallete.textfieldColor),
    borderRadius: BorderRadius.circular(10),
  );

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(12),
      filled: true,
      fillColor: AppPallete.textfieldColor,
      enabledBorder: _border,
      focusedBorder: _border,
      errorBorder: _border,
      focusedErrorBorder: _border,
    ),
  );
}
