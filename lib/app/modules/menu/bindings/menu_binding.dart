import 'package:get/get.dart';
import 'package:nowforecast/app/modules/menu/controllers/menu_controller.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuControllerNF>(() => MenuControllerNF());
  }
}
