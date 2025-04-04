import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: const Color.fromARGB(238, 238, 238, 1000),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(224, 224, 224, 1000),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blueGrey,
  scaffoldBackgroundColor: const Color.fromARGB(48, 48, 48, 1),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(33, 33, 33, 1),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = lightTheme;
  bool _isDarkMode = false;
  Color _iconColor = Colors.black;

  void toggleTheme() async {
    //para cambiar el tema, notificar el cambio al ui y guardar la preferencia
    _isDarkMode = !_isDarkMode;
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    _iconColor = _isDarkMode ? Colors.white : Colors.black;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setString('iconColor', _iconColor == Colors.white ? 'white' : 'black');
  }

  void _loadTheme() async {
    //para obtener la preferencia guardada y cargarla
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    String? savedIconColor = prefs.getString('iconColor');
   _iconColor = (savedIconColor == 'white') ? Colors.white : Colors.black;
    notifyListeners();
  }

  ThemeNotifier() {
    _loadTheme();
  }

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;
  Color get iconColor => _iconColor;
}
