// lib/app/modules/home/bindings/home_binding.dart

import 'package:get/get.dart';
import 'package:nowforecast/app/modules/home/controllers/home_controller.dart';
import 'package:nowforecast/app/modules/settings/controllers/settings_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize SettingsController before HomeController tries to access it
    Get.lazyPut<SettingsController>(() => SettingsController());

    // Then initialize HomeController
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
