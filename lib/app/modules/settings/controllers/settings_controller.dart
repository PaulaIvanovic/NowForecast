import 'package:get/get.dart';

class SettingsController extends GetxController {
  final RxBool isCelsius = true.obs;

  void toggleUnit() {
    isCelsius.value = !isCelsius.value;
  }

  String get unitLabel => isCelsius.value ? "Celsius (°C)" : "Fahrenheit (°F)";
}
