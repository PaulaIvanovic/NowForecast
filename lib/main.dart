import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Add this import for date formatting initialization
import 'package:intl/date_symbol_data_local.dart'; // <--- ADD THIS LINE

import 'package:nowforecast/app/routes/app_pages.dart';

// Make main function async and add necessary initialization
void main() async {
  // <--- CHANGE: Make main async
  WidgetsFlutterBinding.ensureInitialized(); // <--- ADD THIS LINE: Ensures Flutter services are available
  await initializeDateFormatting(
    null,
    null,
  ); // <--- ADD THIS LINE: Initializes locale data
  //      (null, null) uses the system's default locale
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
        brightness: Brightness
            .light, // This might be redundant if set in colorScheme.fromSeed
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL, // Sets the starting route
      getPages: AppPages.routes, // Defines all the routes for navigation
    );
  }
}
