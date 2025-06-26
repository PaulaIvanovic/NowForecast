// lib/app/modules/home/controllers/home_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Make sure to import intl
import 'dart:convert';

import 'package:nowforecast/app/data/models/weather_model.dart';
import 'package:nowforecast/app/data/providers/weather_api_client.dart';

import 'package:nowforecast/app/utils/app_colors.dart';
import 'package:nowforecast/app/utils/app_images.dart';
// Note: Route import removed as it wasn't used in the provided functions
// import 'package:nowforecast/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final WeatherApiClient _weatherApiClient = WeatherApiClient();

  final Rx<WeatherResponse?> weatherData = Rx<WeatherResponse?>(null);
  final RxBool isLoading = true.obs; // Start with loading as true
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Reactive variables for UI display
  final RxString cityName = "Loading...".obs;
  // NOTE: currentTemperature is fetched but not used in the desired design, so it's kept here for potential future use.
  final RxString feelsLikeTemperature = "Loading...".obs;
  final RxString weatherConditionText = "Loading...".obs; // This will hold text like "Partly cloudy"
  final RxString date = "".obs;
  final RxString dayNight = "".obs;
  final RxInt currentWeatherCode = 0.obs;

  final RxList<ForecastDay> forecastDays = <ForecastDay>[].obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // ADDED: Set the default locale for date formatting to Croatian
    // This ensures that `DateFormat('EEE')` will produce "PON", "UTO", etc.
    // For best practice, this line should be in your `main()` function.
    Intl.defaultLocale = 'hr_HR'; 
    
    print("HomeController initialized");
    fetchWeather("Rijeka"); // Initial fetch
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
    print("HomeController closed");
  }

  Future<void> fetchWeather(String city) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    
    try {
      final Map<String, dynamic> rawWeatherData = await _weatherApiClient.fetchWeatherForecast(city, 7);
      final WeatherResponse apiResponse = WeatherResponse.fromJson(rawWeatherData);

      weatherData.value = apiResponse;

      // Update all reactive variables
      cityName.value = apiResponse.location.name;
      feelsLikeTemperature.value = "${apiResponse.current.feelslikeC.round()}\u2103";
      weatherConditionText.value = apiResponse.current.condition.text;
      
      // Use the location's local time for the date
      final String dateOnly = apiResponse.location.localtime.split(' ')[0];
      date.value = DateFormat('dd.MM.yyyy').format(DateTime.parse(dateOnly));

      dayNight.value = apiResponse.current.isDay == 1 ? "DAN" : "NOĆ";
      currentWeatherCode.value = apiResponse.current.condition.code;

      if (apiResponse.forecast != null) {
        forecastDays.assignAll(apiResponse.forecast!.forecastday);
      } else {
        forecastDays.clear();
      }

    } catch (e, st) {
      print("Error fetching weather in HomeController: $e\n$st");
      hasError.value = true;
      errorMessage.value = "Failed to fetch weather data. Please check the city name or your connection.";
      // Simplified error message for the user
      _resetDisplayValuesOnError();
    } finally {
      isLoading.value = false;
    }
  }

  void _resetDisplayValuesOnError() {
    cityName.value = "Error";
    feelsLikeTemperature.value = "--";
    weatherConditionText.value = "Could not fetch data";
    date.value = "--.--.----";
    dayNight.value = "";
    currentWeatherCode.value = 0; // Use a default code for error state
    forecastDays.clear();
  }

  void onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      print("Search submitted: $value");
      // Hide keyboard
      FocusManager.instance.primaryFocus?.unfocus();
      searchController.clear();
      fetchWeather(value);
    }
  }

  void onMenuButtonPressed() {
    print("Menu button pressed in HomeController");
  }

  void onSettingsButtonPressed() {
    print("Settings button pressed in HomeController");
  }

  // --- Helper functions for mapping API codes to assets/colors ---

  // CHANGED: Created a separate helper for the main image for flexibility.
  String getMainWeatherAssetPath(int code) {
    // For now, it can use the same logic as the forecast items.
    // But now you can easily specify different, larger assets for the main display.
    // For example: case 1000: return AppImages.sunMain;
    return getForecastItemAssetPath(code);
  }
  
  String getForecastItemAssetPath(int code) {
    switch (code) {
      case 1000:
        return AppImages.sunForecast; // Sunny
      case 1003:
        return AppImages.rainSunForecast; // Partly cloudy (using rain_sun as a substitute)
      case 1006: // Cloudy
      case 1009:
        return AppImages.cloudForecast; // Overcast
      case 1066: // Patchy snow
      case 1210:
      case 1213:
      case 1216:
      case 1219:
      case 1222:
      case 1225: // Snow variants
        return AppImages.snowForecast;
      case 1087: // Thundery outbreaks
      case 1273:
      case 1276: // Patchy rain with thunder
        return AppImages.thunderstormForecast;
      // Add all rain types
      case 1063:
      case 1150:
      case 1153:
      case 1180:
      case 1183:
      case 1186:
      case 1189:
      case 1192:
      case 1195: // All rain variants
        return AppImages.rainForecast;
      // You can add more specific cases for mist, fog, etc.
      default:
        return AppImages.sunForecast; // A safe default
    }
  }

  Color getForecastItemBackgroundColor(int code) {
    switch (code) {
      case 1000:
        return AppColors.sunBg;
      case 1003:
        return AppColors.rainSunBg;
      case 1006:
      case 1009:
        return AppColors.cloudBg;
      case 1066:
      case 1210:
      case 1213:
      case 1216:
      case 1219:
      case 1222:
      case 1225:
        return AppColors.snowBg;
      case 1087:
      case 1273:
      case 1276:
        return AppColors.thunderstormBg;
      case 1063:
      case 1150:
      case 1153:
      case 1180:
      case 1183:
      case 1186:
      case 1189:
      case 1192:
      case 1195:
        return AppColors.rainBg;
      default:
        return AppColors.defaultGreyBg;
    }
  }

  Color getForecastItemContentColor(int code) {
    return Colors.white;
  }
}
