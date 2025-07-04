import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primaryColor = Color(0xFFF0F0F0);
  static const Color secondaryColor = Color(0xFFE0E0E0);
  static const Color accentColor = Color(0xFF536DFE);
  static final Color defaultGreyBg = Colors.grey.shade300;
  static const Color borderColor = Color.fromARGB(255, 77, 76, 76);
  static const Color textColor = Color(0xFFFFFFFF);

  // Weather background colors directly in the map
  static const Map<int, Color> forecastColors = {
    1000: Color(0xFF5CD9E2),
    1003: Color(0xFF59A7FF),
    1006: Color(0xFF497897),
    1009: Color(0xFF356D92),
    1030: Color(0xFF54507A),
    1063: Color(0xFF59A7FF),
    1066: Color(0xFF5984BD),
    1069: Color(0xFF1E3F85),
    1072: Color(0xFF54507A),
    1087: Color(0xFF5A4722),
    1114: Color(0xFF5984BD),
    1117: Color(0xFF5984BD),
    1135: Color(0xFF54507A),
    1147: Color(0xFF54507A),
    1150: Color(0xFF545F94),
    1153: Color(0xFF545F94),
    1168: Color(0xFF3F3075),
    1171: Color(0xFF3F3075),
    1180: Color(0xFF59A7FF),
    1183: Color(0xFF3F3075),
    1186: Color(0xFF545F94),
    1189: Color(0xFF545F94),
    1192: Color(0xFF545F94),
    1195: Color(0xFF114465),
    1198: Color(0xFF545269),
    1201: Color(0xFF1F5757),
    1204: Color(0xFF60859E),
    1207: Color(0xFF60859E),
    1210: Color(0xFF5984BD),
    1213: Color(0xFF5B8E92),
    1216: Color(0xFF5984BD),
    1219: Color(0xFF5B8E92),
    1222: Color(0xFF5984BD),
    1225: Color(0xFF5B8E92),
    1237: Color(0xFF75597C),
    1240: Color(0xFF545F94),
    1243: Color(0xFF545F94),
    1246: Color(0xFF545F94),
    1249: Color(0xFF52886A),
    1252: Color(0xFF52886A),
    1255: Color(0xFF5984BD),
    1258: Color(0xFF5984BD),
    1261: Color(0xFF397A5A),
    1264: Color(0xFF397A5A),
    1273: Color(0xFF143B91),
    1276: Color(0xFFA4A397),
    1279: Color(0xFF2D5A5A),
    1282: Color(0xFF2D5A5A),
  };
}
