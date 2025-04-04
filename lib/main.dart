import 'package:flutter/material.dart';
import '../routes/routes.dart';
import 'package:provider/provider.dart';
import '../themes/themes.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeNotifier(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          theme: themeNotifier.currentTheme, //esto cambia el tema

          initialRoute: '/',
          routes: AppRoutes.getRoutes(),
        );
      },
    );
  }
}
