// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/theme_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeService _themeService = ThemeService();

  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final savedTheme = await _themeService.loadTheme();

      if (!mounted) return;

      setState(() {
        _isDarkMode = savedTheme;
      });
    } catch (error) {
      debugPrint('Could not load theme: $error');
    }
  }

  Future<void> _toggleTheme() async {
    final nextTheme = !_isDarkMode;
    try {
      await _themeService.saveTheme(nextTheme);
      if (!mounted) return;
      setState(() {
        _isDarkMode = nextTheme;
      });
    } catch (error) {
      if (!mounted) return;
      debugPrint('Could not save theme: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: HomeScreen(isDarkMode: _isDarkMode, onToggleTheme: _toggleTheme),
    );
  }
}
