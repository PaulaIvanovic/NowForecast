import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuControllerNF extends GetxController {
  final RxList<String> savedCities = <String>[].obs;
  static const _storageKey = 'savedCities';
  @override
void onReady() {
    super.onReady();
    _loadInitialLocations();
  }


  // Load saved cities from local storage
  Future<void> _loadInitialLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedCities = prefs.getStringList(_storageKey);
    if (storedCities != null && storedCities.isNotEmpty) {
      savedCities.addAll(storedCities);
    } else {
      // Optional: add default cities on first launch
      savedCities.addAll(['Rijeka', 'Zagreb', 'Split']);
      await _saveToStorage();
    }
  }

  String _normalize(String city) => city.trim().toLowerCase();

  bool isSaved(String city) {
    final normCity = _normalize(city);
    return savedCities.any((c) => _normalize(c) == normCity);
  }

  void toggleLocation(String city) {
    final normCity = _normalize(city);
    final match = savedCities.firstWhereOrNull((c) => _normalize(c) == normCity);
    if (match != null) {
      savedCities.remove(match);
    } else {
      savedCities.add(city.trim());
    }
    _saveToStorage();
  }

  void removeCity(String city) {
    final normCity = _normalize(city);
    savedCities.removeWhere((c) => _normalize(c) == normCity);
    _saveToStorage();
  }

  // Save the updated list to persistent storage
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, savedCities.toList());
  }
}
