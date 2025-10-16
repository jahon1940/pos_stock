import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightGrey,
        primaryColor: AppColors.primary500,
        primaryColorLight: AppColors.primary100,
        primaryColorDark: AppColors.primary900,
        canvasColor: AppColors.white,
        cardColor: AppColors.white,
        dividerColor: AppColors.stroke,
        focusColor: AppColors.softGrey,
        hoverColor: AppColors.stroke,
        highlightColor: AppColors.primary200,
        splashColor: AppColors.primary300.opcty(0.3),
        shadowColor: AppColors.shadowColor,
        indicatorColor: AppColors.primary500,
        disabledColor: AppColors.secondary200,
        hintColor: AppColors.secondary200,
        unselectedWidgetColor: AppColors.secondary300,
        secondaryHeaderColor: AppColors.secondary100,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary500,
          onPrimary: AppColors.white,
          secondary: AppColors.secondary500,
          onSecondary: AppColors.white,
          error: AppColors.error500,
          onError: AppColors.white,
          surface: AppColors.white,
          onSurface: AppColors.secondary500,
        ),

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.secondary500,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.secondary500),
        ),

        // Bottom Navigation Bar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary500,
          unselectedItemColor: AppColors.secondary300,
          selectedIconTheme: IconThemeData(color: AppColors.primary500),
          unselectedIconTheme: IconThemeData(color: AppColors.secondary300),
        ),

        // Floating Action Button
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary500,
          foregroundColor: AppColors.white,
          elevation: 4,
        ),

        // Elevated Button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary500,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.primary100,
            disabledForegroundColor: AppColors.primary200,
            shadowColor: AppColors.shadowColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),

        // Text Button
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary500,
          ),
        ),

        // Outlined Button
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary500,
            side: const BorderSide(color: AppColors.primary500),
          ),
        ),

        // Input Decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.softGrey,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.stroke),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.stroke),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary500),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error500),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error700),
          ),
          hintStyle: AppTextStyles.mType14.copyWith(color: AppColors.secondary200),
          labelStyle: AppTextStyles.mType14.copyWith(color: AppColors.secondary300),
        ),

        // Checkbox
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(AppColors.primary500),
          checkColor: WidgetStateProperty.all(AppColors.white),
        ),

        // Radio
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.all(AppColors.primary500),
        ),

        // Switch
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary500;
            }
            return AppColors.secondary300;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary200;
            }
            return AppColors.secondary100;
          }),
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: AppColors.stroke,
          thickness: 1,
        ),
        dialogTheme: const DialogThemeData(backgroundColor: AppColors.white),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.secondary800,
        primaryColor: AppColors.primary500,
        primaryColorLight: AppColors.primary300,
        primaryColorDark: AppColors.primary900,
        canvasColor: AppColors.secondary700,
        cardColor: AppColors.secondary500,
        dividerColor: AppColors.stroke,
        focusColor: AppColors.softGrey,
        hoverColor: AppColors.primary200.opcty(0.1),
        highlightColor: AppColors.primary300.opcty(0.2),
        splashColor: AppColors.primary300.opcty(0.3),
        shadowColor: AppColors.shadowColor,
        indicatorColor: AppColors.primary500,
        disabledColor: AppColors.secondary200,
        hintColor: AppColors.secondary200,
        unselectedWidgetColor: AppColors.secondary300,
        secondaryHeaderColor: AppColors.secondary400,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.primary500,
          onPrimary: AppColors.white,
          secondary: AppColors.secondary500,
          onSecondary: AppColors.white,
          error: AppColors.error500,
          onError: AppColors.white,
          surface: AppColors.secondary700,
          onSurface: AppColors.secondary100,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.secondary700,
          foregroundColor: AppColors.secondary100,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.secondary100),
          titleTextStyle: AppTextStyles.mType14.copyWith(color: AppColors.secondary100),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.secondary700,
          selectedItemColor: AppColors.primary500,
          unselectedItemColor: AppColors.secondary300,
          selectedIconTheme: IconThemeData(color: AppColors.primary500),
          unselectedIconTheme: IconThemeData(color: AppColors.secondary300),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary500,
          foregroundColor: AppColors.white,
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary500,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.primary100,
            disabledForegroundColor: AppColors.primary200,
            shadowColor: AppColors.shadowColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary400,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary400,
            side: const BorderSide(color: AppColors.primary400),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.secondary600,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.stroke),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.stroke),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary500),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error500),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error700),
          ),
          hintStyle: AppTextStyles.mType14.copyWith(color: AppColors.secondary200),
          labelStyle: AppTextStyles.mType14.copyWith(color: AppColors.secondary300),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(AppColors.primary500),
          checkColor: WidgetStateProperty.all(AppColors.white),
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.all(AppColors.primary500),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary500;
            }
            return AppColors.secondary300;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary200;
            }
            return AppColors.secondary100;
          }),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.stroke,
          thickness: 1,
        ),
        dialogTheme: const DialogThemeData(backgroundColor: AppColors.secondary600),
      );
}
