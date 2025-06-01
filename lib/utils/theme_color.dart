// theme_colors.dart
import 'package:atal_without_krishna/utils/theme_provider.dart';
import 'package:flutter/material.dart';

class ThemeColors {
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onBackground;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onBackground.withOpacity(0.7);
  }

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).isDarkMode ? AppTheme.cardDark : AppTheme.cardLight;
  }

  static Color getAccentColor(BuildContext context) {
    return AppTheme.accentColor;
  }

  static List<Color> getGradientColors(BuildContext context) {
    return Theme.of(context).isDarkMode ? AppTheme.gradientDark : AppTheme.gradientLight;
  }
}

extension ThemeExtension on ThemeData {
  bool get isDarkMode => brightness == Brightness.dark;
}