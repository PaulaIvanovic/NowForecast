import 'package:get/get.dart';

import 'package:nowforecast/app/modules/home/bindings/home_binding.dart';
import 'package:nowforecast/app/modules/home/views/home_view.dart';

// imports that are not yet used but will be:
// import 'package:nowforecast/app/modules/settings/bindings/settings_binding.dart';
// import 'package:nowforecast/app/modules/settings/views/settings_view.dart';
// import 'package:nowforecast/app/modules/menu/bindings/menu_binding.dart';
// import 'package:nowforecast/app/modules/menu/views/menu_view.dart';

part 'app_routes.dart'; // Links to app_routes.dart

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
    pages that are not yet used but will be: 
    
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
