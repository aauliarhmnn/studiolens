import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Color(0xFF111111);
  static const Color pink = Color(0xFFFFB6C1);
  static const Color blue = Color(0xFF7BB8C9);
  static const Color royal = Color(0xFF0033CC);
  static const Color lime = Color(0xFFE0E96A);
  static const Color salmon = Color(0xFFF4957A);
  static const Color purple = Color(0xFFE0A8FF);
  static const Color mint = Color(0xFFD0F0DC);
  static const Color grey = Color(0xFFE8E8E8);
  static const Color red = Color(0xFFD0002F);
}

class AppText {
  static TextStyle heading(double size, {Color color = AppColors.black}) =>
      TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
        height: 1.05,
        color: color,
      );

  static TextStyle label(double size, {Color color = AppColors.black}) =>
      TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
        color: color,
      );

  static TextStyle body(double size, {Color color = AppColors.black}) =>
      TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: color,
      );
}

InputDecoration neoInput(String hint) {
  OutlineInputBorder border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: c, width: 3),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: border(AppColors.black),
    enabledBorder: border(AppColors.black),
    focusedBorder: border(AppColors.royal),
    errorBorder: border(AppColors.red),
    focusedErrorBorder: border(AppColors.red),
    errorStyle: const TextStyle(
        color: AppColors.red, fontWeight: FontWeight.w700, fontSize: 11),
  );
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        splashFactory: NoSplash.splashFactory,
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: AppColors.black),
      );
}