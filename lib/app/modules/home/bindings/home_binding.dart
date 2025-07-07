import 'package:get/get.dart';
import 'package:nowforecast/app/modules/home/controllers/home_controller.dart';
import 'package:nowforecast/app/modules/settings/controllers/settings_controller.dart';
import 'package:nowforecast/app/modules/menu/controllers/menu_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<MenuControllerNF>(() => MenuControllerNF());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
