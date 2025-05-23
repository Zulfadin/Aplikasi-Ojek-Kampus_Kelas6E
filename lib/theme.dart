import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF167A8B);
  static const Color primaryLight = Color(0xFF4DA9BB);
  static const Color primaryDark = Color(0xFF004D5C);

  // Secondary Colors
  static const Color secondary = Color(0xFFE3F2FD);
  static const Color secondaryLight = Color(0xFFF5FBFF);
  static const Color secondaryDark = Color(0xFFB1C0C8);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF424242);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
}

class AppTextStyles {
  // Headlines
  static const TextStyle headline4 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle headline5 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle headline6 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Subtitles
  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  // Body Text
  static const TextStyle bodyText1 = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 13,
    color: Colors.black54,
  );

  // Buttons
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  // AppBar
  static const TextStyle appBarTitle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // Section Header
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  // Location Text
  static const TextStyle locationTitle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15,
  );

  static const TextStyle locationSubtitle = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
}
