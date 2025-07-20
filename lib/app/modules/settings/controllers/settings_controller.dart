import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final RxBool isCelsius = true.obs;
  static const _unitKey = 'isCelsius';

  @override
  void onReady() {
    super.onReady();
    _loadUnitPreference();
  }

  // Load the saved temperature unit preference
  Future<void> _loadUnitPreference() async {
    final prefs = await SharedPreferences.getInstance();
    isCelsius.value = prefs.getBool(_unitKey) ?? true; // Default to Celsius
  }

  // Toggle and persist the unit preference
  void toggleUnit() async {
    isCelsius.value = !isCelsius.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_unitKey, isCelsius.value);
  }

  String get unitLabel => isCelsius.value ? "Celsius (°C)" : "Fahrenheit (°F)";
}
