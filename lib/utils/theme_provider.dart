import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeKey) ?? 0;
    _themeMode = ThemeMode.values[themeModeIndex];
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    notifyListeners();
  }

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}

// app_theme.dart
class AppTheme {
  // Primary Colors
  static const Color primaryLight = Color(0xFF2C3E50);
  static const Color primaryDark = Color(0xFF34495E);
  static const Color accentColor = Color(0xFFc89b3c);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFCFDFD);
  static const Color backgroundDark = Color(0xFF1A1A1A);

  // Surface Colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2D2D2D);

  // Card Colors
  static const Color cardLight = Color(0xFFEAE9E9);
  static const Color cardDark = Color(0xFF3A3A3A);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // Gradient Colors
  static const List<Color> gradientLight = [
    Color(0xFF2C3E50),
    Color(0xFF34495E),
    Color(0xFF2C3E50),
  ];

  static const List<Color> gradientDark = [
    Color(0xFF1A1A1A),
    Color(0xFF2D2D2D),
    Color(0xFF1A1A1A),
  ];

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: MaterialColor(0xFF2C3E50, {
      50: Color(0xFFE8EAF0),
      100: Color(0xFFC5CAD9),
      200: Color(0xFF9FA8C0),
      300: Color(0xFF7885A7),
      400: Color(0xFF5A6A94),
      500: Color(0xFF2C3E50),
      600: Color(0xFF273649),
      700: Color(0xFF212D40),
      800: Color(0xFF1B2437),
      900: Color(0xFF10162A),
    }),
    scaffoldBackgroundColor: backgroundLight,
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundLight,
      foregroundColor: textPrimaryLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimaryLight,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardTheme(
      color: cardLight,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryLight, width: 2),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: primaryLight,
      secondary: accentColor,
      surface: surfaceLight,
      background: backgroundLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimaryLight,
      onBackground: textPrimaryLight,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: MaterialColor(0xFF34495E, {
      50: Color(0xFFE8EBF0),
      100: Color(0xFFC6CDD9),
      200: Color(0xFFA0ABC0),
      300: Color(0xFF7A89A7),
      400: Color(0xFF5E6F94),
      500: Color(0xFF34495E),
      600: Color(0xFF2F4156),
      700: Color(0xFF29384C),
      800: Color(0xFF232F42),
      900: Color(0xFF171F32),
    }),
    scaffoldBackgroundColor: backgroundDark,
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimaryDark,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardTheme(
      color: cardDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF3A3A3A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryDark, width: 2),
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: primaryDark,
      secondary: accentColor,
      surface: surfaceDark,
      background: backgroundDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimaryDark,
      onBackground: textPrimaryDark,
    ),
  );
}
