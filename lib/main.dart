import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const StudioLensApp());

class StudioLensApp extends StatelessWidget {
  const StudioLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STUDIOLENS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}