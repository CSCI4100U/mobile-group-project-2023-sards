import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';

class ThemeManager with ChangeNotifier {
  ThemeData? lightTheme;
  ThemeData? darkTheme;
  bool? isDarkMode;

  ThemeManager() {
    isDarkMode = true; // Set the initial theme mode to dark
    loadThemesFromAssets(); // Load themes from JSON
  }


  Future<void> loadThemesFromAssets() async {
    final lightThemeJson = await rootBundle.loadString('assets/light.json');
    final darkThemeJson = await rootBundle.loadString('assets/theme.json');

    lightTheme = ThemeDecoder.decodeThemeData(jsonDecode(lightThemeJson))!;
    darkTheme = ThemeDecoder.decodeThemeData(jsonDecode(darkThemeJson))!;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode!;
    notifyListeners();
  }
}
