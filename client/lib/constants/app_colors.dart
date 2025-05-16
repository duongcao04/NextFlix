import 'package:flutter/material.dart';

class AppColors {
  static const MaterialColor primary =
      MaterialColor(_primaryValue, <int, Color>{
        50: Color(0xFFFAFAFA),
        100: Color(0xFFF5F5F5),
        200: Color(0xFFE5E5E5),
        300: Color(0xFFD4D4D4),
        400: Color(0xFFA1A1A1),
        500: Color(0xFF737373),
        600: Color(0xFF525252),
        700: Color(0xFF404040),
        800: Color(0xFF262626),
        900: Color(0xFF171717),
        950: Color(0xFF0A0A0A),
      });

  static const int _primaryValue = 0xFF737373;
}
