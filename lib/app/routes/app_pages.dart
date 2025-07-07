// lib/app/routes/app_pages.dart

import 'package:get/get.dart';

import 'package:nowforecast/app/modules/home/bindings/home_binding.dart';
import 'package:nowforecast/app/modules/home/views/home_view.dart';

import 'package:nowforecast/app/modules/settings/bindings/settings_binding.dart';
import 'package:nowforecast/app/modules/settings/views/settings_view.dart';

import 'package:nowforecast/app/modules/menu/bindings/menu_binding.dart';
import 'package:nowforecast/app/modules/menu/views/menu_view.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    
    GetPage(name: Routes.MENU, page: () => const MenuView(), binding: MenuBinding()),
  ];
}
