import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Save theme to storage
  void saveTheme(bool isDarkMode) => _box.write(_key, isDarkMode);

  // Load theme from storage
  bool isDarkMode() => _box.read(_key) ?? false;

  // Get current ThemeMode
  ThemeMode get theme => isDarkMode() ? ThemeMode.dark : ThemeMode.light;

  // Toggle and save
  void switchTheme() {
    bool newValue = !isDarkMode();
    Get.changeThemeMode(newValue ? ThemeMode.dark : ThemeMode.light);
    saveTheme(newValue);
  }
}
