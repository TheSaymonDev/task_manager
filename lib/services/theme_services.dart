import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_manager/reusables/colors.dart';

class ThemeServices {
  static final light = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(color: lightPrimaryClr),
    brightness: Brightness.light,
    scaffoldBackgroundColor: whiteClr,
  );

  static final dark = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(color: textClr),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkPrimaryClr,
  );

  final _getStorage = GetStorage();
  final _darkThemeKey = 'isDarkTheme';

  void saveThemeData(bool isDarkMode) {
    _getStorage.write(_darkThemeKey, isDarkMode);
  }

  bool isSavedDarkMode() {
    return _getStorage.read(_darkThemeKey) ?? false;
  }

  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  void changeTheme() {
    Get.changeThemeMode(isSavedDarkMode() ? ThemeMode.light : ThemeMode.dark);
    saveThemeData(!isSavedDarkMode());
  }
}
