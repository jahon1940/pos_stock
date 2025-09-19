import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/mixins/secure_storage_mixin.dart';

class ThemeProvider extends ChangeNotifier with SecureStorageMixin {
  ThemeMode themeMode = ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() async {
    themeMode = (themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    await writeData(SecureStorageKeys.darkMode, themeMode == ThemeMode.dark ? "1" : "0");
  }

  void _loadTheme() async {
    final bool isDark = (await getData(SecureStorageKeys.darkMode) ?? "0") == "1";
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
