import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:nowforecast/app/routes/app_pages.dart';
import 'package:nowforecast/app/modules/menu/controllers/menu_controller.dart';
import 'package:nowforecast/app/modules/settings/controllers/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize locale-specific formatting
  await initializeDateFormatting(null, null);

  // Inject your GetX controllers globally
  Get.put(MenuControllerNF());
  Get.put(SettingsController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NowForecast',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey.shade300,
          brightness: Brightness.light,
        ),
      ),
    );
  }
}
