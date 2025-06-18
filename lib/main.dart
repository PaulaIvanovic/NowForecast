import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nowforecast/app/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Use GetMaterialApp for GetX features
      title: 'NowForecast',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey.shade300,
          brightness: Brightness.light,
        ),
        brightness: Brightness.light,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL, // Sets the starting route
      getPages: AppPages.routes, // Defines all the routes for navigation
    );
  }
}
