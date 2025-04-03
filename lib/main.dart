import 'package:flutter/material.dart';
import '../routes/routes.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: AppRoutes.getRoutes(),
    )
  );
}
