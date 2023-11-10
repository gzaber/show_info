import 'package:flutter/material.dart';

class AppTheme {
  final _appBarTheme = const AppBarTheme(centerTitle: true);
  final _snackBarTheme =
      const SnackBarThemeData(behavior: SnackBarBehavior.floating);

  ThemeData get light {
    return ThemeData.light(useMaterial3: true).copyWith(
      appBarTheme: _appBarTheme,
      snackBarTheme: _snackBarTheme,
    );
  }

  ThemeData get dark {
    return ThemeData.dark(useMaterial3: true).copyWith(
      appBarTheme: _appBarTheme,
      snackBarTheme: _snackBarTheme,
    );
  }
}
