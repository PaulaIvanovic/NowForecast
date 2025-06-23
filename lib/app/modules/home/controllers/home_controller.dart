import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import app packages
import 'package:nowforecast/app/utils/app_colors.dart';
import 'package:nowforecast/app/utils/app_images.dart';

import 'package:nowforecast/app/routes/app_pages.dart'; // For navigation to other routes

class HomeController extends GetxController {
  // Make state variables reactive using .obs
  final cityName = "Rijeka"
      .obs; // Will be based on location or searched city - .obs to make it observable by GetX
  final weatherCondition =
      "snow".obs; // For main display: "sunny_day", "thunderstorm_day", etc.
  final feelsLikeTemperature = "20\u2103".obs;
  final date = "25.05.2025".obs;
  final dayNight = "DAN".obs;

  final TextEditingController searchController = TextEditingController();

  final RxList<Map<String, String>> forecast = <Map<String, String>>[
    {
      "day": "PON 26.05.",
      "temp": "22\u2103 / 15\u2103",
      "icon_type": "moon_stars",
    },
    {"day": "UTO 27.05.", "temp": "20\u2103 / 13\u2103", "icon_type": "snow"},
    {
      "day": "SRI 28.05.",
      "temp": "23\u2103 / 16\u2103",
      "icon_type": "rain_sun",
    },
    {"day": "ČET 29.05.", "temp": "19\u2103 / 14\u2103", "icon_type": "rain"},
    {
      "day": "PET 30.05.",
      "temp": "18\u2103 / 12\u2103",
      "icon_type": "thunderstorm",
    },
    {"day": "SUB 31.05.", "temp": "25\u2103 / 18\u2103", "icon_type": "sun"},
    {"day": "NED 01.06.", "temp": "22\u2103 / 15\u2103", "icon_type": "cloud"},
  ].obs; // Whole list reactive!

  // Lifecycle method: Called when the controller is first initialized (e.g., when HomePage is shown)
  @override
  void onInit() {
    super.onInit();
    // TODO: load initial data, fetch current location weather...

    print("HomeController initialized");
  }

  // Lifecycle method: Called when the controller is removed from memory
  @override
  void onClose() {
    searchController.dispose(); // Dispose the TextEditingController
    super.onClose();
    print("HomeController closed");
  }

  //SEARCH
  void onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      cityName.value = value; // Update reactive city name
      print("Search submitted: $value");
      searchController.clear();
      // TODO: Integrate Weather API here.

      // For now, just simulate a change:
      weatherCondition.value = "rain_sun";
      feelsLikeTemperature.value = "25\u2103";
      date.value = "17.06.2025";
      dayNight.value = "DAN";
      // TODO: Update the forecast list based on new data from API
      forecast.assignAll([
        {
          "day": "PON 17.06.",
          "temp": "25\u2103 / 18\u2103",
          "icon_type": "rain_sun",
        },
        {
          "day": "UTO 18.06.",
          "temp": "23\u2103 / 16\u2103",
          "icon_type": "cloud",
        },
        {
          "day": "SRI 19.06.",
          "temp": "20\u2103 / 14\u2103",
          "icon_type": "rain",
        },
        {
          "day": "ČET 29.05.",
          "temp": "19\u2103 / 14\u2103",
          "icon_type": "rain",
        },
        {
          "day": "PET 30.05.",
          "temp": "18\u2103 / 12\u2103",
          "icon_type": "thunderstorm",
        },
        {
          "day": "SUB 31.05.",
          "temp": "25\u2103 / 18\u2103",
          "icon_type": "sun",
        },
        {
          "day": "NED 01.06.",
          "temp": "22\u2103 / 15\u2103",
          "icon_type": "cloud",
        },
        // ... more updated forecast data
      ]);
    }
  }

  // Logic for Menu button
  void onMenuButtonPressed() {
    print("Menu button pressed in HomeController");
    // TODO: Navigate to Menu/Saved Locations screen
    // Get.toNamed(Routes.MENU);
  }

  // Logic for Settings button
  void onSettingsButtonPressed() {
    print("Settings button pressed in HomeController");
    // TODO: Navigate to Settings screen
  }

  //Helper functions for asset paths and colors
  //TODO: define more different weather options - based on API
  String getForecastItemAssetPath(String iconType) {
    switch (iconType.toLowerCase()) {
      case 'moon_stars':
        return AppImages.moonStarsForecast;
      case 'moon_cloud':
        return AppImages.moonCloudyForecast;
      case 'moon_dark_cloud':
        return AppImages.moonCloudDarkForecast;
      case 'snow':
        return AppImages.snowForecast;
      case 'rain_sun':
        return AppImages.rainSunForecast;
      case 'rain':
        return AppImages.rainForecast;
      case 'thunderstorm':
        return AppImages.thunderstormForecast;
      case 'sun':
        return AppImages.sunForecast;
      case 'cloud':
        return AppImages.cloudForecast;
      case 'wind':
        return AppImages.windDayForecast;
      default:
        return AppImages.sunForecast;
    }
  }

  //TODO: define more colors for different weather
  Color getForecastItemBackgroundColor(String iconType) {
    switch (iconType.toLowerCase()) {
      case 'moon_stars':
        return AppColors.moonStarsBg;
      case 'snow':
        return AppColors.snowBg;
      case 'rain_sun':
        return AppColors.rainSunBg;
      case 'rain':
        return AppColors.rainBg;
      case 'thunderstorm':
        return AppColors.thunderstormBg;
      case 'sun':
        return AppColors.sunBg;
      case 'cloud':
        return AppColors.cloudBg;
      default:
        return AppColors.defaultGreyBg;
    }
  }

  Color getForecastItemContentColor(String iconType) {
    return Colors.white;
  }
}
