import 'package:get/get.dart';

class MenuControllerNF extends GetxController {
  // Observable list of saved cities
  final RxList<String> savedCities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialLocations();
  }

  // Load initial saved cities (can be replaced with storage later)
  void _loadInitialLocations() {
    savedCities.addAll(['Rijeka', 'Zagreb', 'Split']);
    // TODO: Load from local storage or cloud
  }

  // Normalize city names for consistent storage
  String _normalize(String city) => city.trim().toLowerCase();

  // Check if a city is saved
  bool isSaved(String city) {
    final normCity = _normalize(city);
    return savedCities.any((c) => _normalize(c) == normCity);
  }

  // Add or remove a city based on its presence
  void toggleLocation(String city) {
    final normCity = _normalize(city);
    final match = savedCities.firstWhereOrNull((c) => _normalize(c) == normCity);
    if (match != null) {
      savedCities.remove(match);
    } else {
      savedCities.add(city.trim());
    }
    // TODO: Save updated list to persistent storage
  }

  // Explicitly remove a city
  void removeCity(String city) {
    final normCity = _normalize(city);
    savedCities.removeWhere((c) => _normalize(c) == normCity);
    // TODO: Persist changes
  }
}
