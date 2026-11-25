import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'is_dark_mode';

  Future<bool> loadTheme() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_themeKey) ?? false;
  }

  Future<void> saveTheme(bool isDarkMode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_themeKey, isDarkMode);
  }
}
