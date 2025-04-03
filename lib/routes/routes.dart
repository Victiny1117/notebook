import 'package:flutter/material.dart';
import '../screens/home.dart';

class AppRoutes  {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => HomeScreen(),
    };
  }
}
