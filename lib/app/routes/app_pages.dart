// lib/app/routes/app_pages.dart

import 'package:get/get.dart';

import 'package:nowforecast/app/modules/home/bindings/home_binding.dart';
import 'package:nowforecast/app/modules/home/views/home_view.dart';

// <--- CRITICAL CHANGE: Use 'part' instead of 'import' for app_routes.dart
part 'app_routes.dart';

// Keep these imports and their corresponding GetPage entries COMMENTED OUT
// until you have physically created these files in your project.
// import 'package:nowforecast/app/modules/settings/bindings/settings_binding.dart';
// import 'package:nowforecast/app/modules/settings/views/settings_view.dart';
// import 'package:nowforecast/app/modules/menu/bindings/menu_binding.dart';
// import 'package:nowforecast/app/modules/menu/views/menu_view.dart';

class AppPages {
  AppPages._(); // Private constructor

  static const INITIAL = Routes.HOME; // The first/initial screen that loads

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    /*
    // DO NOT UNCOMMENT THESE UNTIL YOU CREATE THE ACTUAL FILES:
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: _Paths.MENU,
      page: () => const MenuView(),
      binding: MenuBinding(),
    ),*/
  ];
}
