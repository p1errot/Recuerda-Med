import 'package:flutter/material.dart';

const Color _customColorTheme = Color.fromARGB(0, 34, 220, 78);

const List<Color> _colorThemes = [
  _customColorTheme,
  Color.fromARGB(0, 3, 249, 245),
  Colors.teal,
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.pink,
  
];

class AppTheme {
  final int selectColor;

  AppTheme({this.selectColor = 0})
    : assert(selectColor >= 0, "está fuera de los valores determinados");
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectColor],
    );
  }
}
