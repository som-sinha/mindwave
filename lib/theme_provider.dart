import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData getTheme() {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  final ThemeData _lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
      foregroundColor: Colors.white,
    ),
  );

  final ThemeData _darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[900],
    textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)),
    appBarTheme: const AppBarTheme(
      color: Colors.blueGrey,
      foregroundColor: Colors.white,
    ),
  );
}
