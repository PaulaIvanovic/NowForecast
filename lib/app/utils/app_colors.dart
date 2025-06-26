import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primaryColor = Color(0xFFF0F0F0);
  static const Color secondaryColor = Color(0xFFE0E0E0);
  static const Color accentColor = Color(0xFF536DFE);

  static const Color textColor = Color(
    0xFFFFFFFF,
  ); // Or any color you prefer for text

  static const Color moonStarsBg = Color(0xFF114465);
  static const Color snowBg = Color(0xFF5984BD);
  static const Color rainSunBg = Color(0xFF59A7FF);
  static const Color rainBg = Color(0xFF979BAE);
  static const Color thunderstormBg = Color(0xFFA4A397);
  static const Color sunBg = Color(0xFF5CD9E2);
  static const Color cloudBg = Color(0xFF59A7FF);
  static Color defaultGreyBg =
      Colors.grey.shade300; // Original default background
  static const Color borderColor = Color.fromARGB(255, 77, 76, 76);
  //add more colors if needed based on API
}
