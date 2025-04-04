import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/developer_info_screen.dart';

class AppRoutes  {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => HomeScreen(),
      '/devInfo': (context) => DeveloperInfoScreen(),
    };
  }
}
