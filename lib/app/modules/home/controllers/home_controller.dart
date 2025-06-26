// lib/app/modules/home/controllers/home_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:nowforecast/app/data/models/weather_model.dart';
import 'package:nowforecast/app/data/providers/weather_api_client.dart';

import 'package:nowforecast/app/utils/app_colors.dart';
import 'package:nowforecast/app/utils/app_images.dart';
import 'package:nowforecast/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final WeatherApiClient _weatherApiClient = WeatherApiClient();

  final Rx<WeatherResponse?> weatherData = Rx<WeatherResponse?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Reactive variables for UI display
  final RxString cityName = "Loading...".obs;
  final RxString currentTemperature = "Loading...".obs;
  final RxString feelsLikeTemperature = "Loading...".obs;
  final RxString weatherConditionText = "Loading...".obs;
  final RxString currentIconUrl = "".obs;
  final RxString date = "".obs;
  final RxString dayNight = "".obs;
  final RxInt currentWeatherCode = 0.obs; // Default to 0 

  // Reactive list for forecast day codes 
  final RxList<int> forecastCodes = <int>[].obs;

  final RxList<ForecastDay> forecastDays = <ForecastDay>[].obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    print("HomeController initialized");
    fetchWeather("Rijeka");
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
    weatherData.value = null;

    try {
      final Map<String, dynamic> rawWeatherData = await _weatherApiClient.fetchWeatherForecast(city, 7);

      final WeatherResponse apiResponse = WeatherResponse.fromJson(rawWeatherData);

      weatherData.value = apiResponse;

      cityName.value = apiResponse.location.name;
      currentTemperature.value = "${apiResponse.current.tempC.round()}\u2103";
      feelsLikeTemperature.value = "${apiResponse.current.feelslikeC.round()}\u2103";
      weatherConditionText.value = apiResponse.current.condition.text;
      currentIconUrl.value = 'https:${apiResponse.current.condition.icon}';

      final String dateOnly = apiResponse.location.localtime.split(' ')[0];
      date.value = DateFormat('dd.MM.yyyy').format(DateTime.parse(dateOnly));

      dayNight.value = apiResponse.current.isDay == 1 ? "DAN" : "NOĆ";

      // Assign the current weather code
      currentWeatherCode.value = apiResponse.current.condition.code; // <--- HERE IT IS!

      if (apiResponse.forecast != null) {
        forecastDays.assignAll(apiResponse.forecast!.forecastday);
        forecastCodes.assignAll(apiResponse.forecast!.forecastday.map((day) => day.day.condition.code).toList());
      } else {
        forecastDays.clear();
        forecastCodes.clear(); // Clear forecast codes too
      }
    } catch (e, st) {
      print("Error fetching weather in HomeController: $e\n$st");
      hasError.value = true;
      errorMessage.value = "Failed to fetch weather data. Please check your internet connection, city name, or API key.\nDetails: $e";

      if (e is Exception && e.toString().contains("Failed to load")) {
        try {
          final String errorString = e.toString().replaceFirst('Exception: ', '');
          final int firstBrace = errorString.indexOf('{');
          if (firstBrace != -1) {
            final String jsonPart = errorString.substring(firstBrace);
            final errorBody = json.decode(jsonPart);
            if (errorBody['error'] != null && errorBody['error']['message'] != null) {
              errorMessage.value = errorBody['error']['message'];
            }
          }
        } catch (_) {
          // ignore parsing error
        }
      }
      _resetDisplayValues();
    } finally {
      isLoading.value = false;
    }
  }

  void _resetDisplayValues() {
    cityName.value = "Error/No Data";
    currentTemperature.value = "--";
    feelsLikeTemperature.value = "--";
    weatherConditionText.value = "Unknown";
    currentIconUrl.value = "";
    date.value = "--.--.----";
    dayNight.value = "";
    currentWeatherCode.value = 0;
    forecastDays.clear();
    forecastCodes.clear();
  }

  void onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      print("Search submitted: $value");
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

  // Helper functions for asset paths and colors - use code
  String getForecastItemAssetPath(int code) {
    // receive the weather code from the API
    // Map the codes to local image names.
    switch (code) {
      case 1000: // Clear/Sunny
        return AppImages.sunForecast;
      case 1003: // Partly cloudy
        return AppImages.cloudForecast;
      case 1006: // Cloudy
      case 1009: // Overcast
        return AppImages.cloudForecast;
      case 1030: // Mist
      case 1063: // Patchy light rain
      case 1180: // Patchy light drizzle
      case 1183: // Light drizzle
      case 1186: // Light rain
      case 1189: // Moderate rain
      case 1192: // Heavy rain at times
      case 1195: // Heavy rain
        return AppImages.rainForecast;
      case 1066: // Patchy light snow
      case 1114: // Blowing snow
      case 1117: // Blizzard
      case 1210: // Patchy light snow
      case 1213: // Light snow
      case 1216: // Patchy moderate snow
      case 1219: // Moderate snow
      case 1222: // Patchy heavy snow
      case 1225: // Heavy snow
        return AppImages.snowForecast;
      case 1087: // Thundery outbreaks possible
      case 1279: // Patchy light rain with thunder
      case 1282: // Moderate or heavy rain with thunder
        return AppImages.thunderstormForecast;
      // add more cases for all the codes 
      // Refer to WeatherAPI.com's condition codes: https://www.weatherapi.com/docs/weather_conditions.json
      default:
        // Default to a generic icon if code is not explicitly handled
        return AppImages.sunForecast;
    }
  }

  Color getForecastItemBackgroundColor(int code) {
    // Similar to asset path, map codes to colors
    switch (code) {
      case 1000: // Clear/Sunny
        return AppColors.sunBg;
      case 1003: // Partly cloudy
      case 1006: // Cloudy
      case 1009: // Overcast
        return AppColors.cloudBg;
      case 1063: // Patchy light rain
      case 1180:
      case 1183:
      case 1186:
      case 1189:
      case 1192:
      case 1195:
        return AppColors.rainBg;
      case 1066: // Patchy light snow
      case 1114:
      case 1117:
      case 1210:
      case 1213:
      case 1216:
      case 1219:
      case 1222:
      case 1225:
        return AppColors.snowBg;
      case 1087: // Thundery outbreaks possible
      case 1279:
      case 1282:
        return AppColors.thunderstormBg;
      // Add more cases here
      default:
        return AppColors.defaultGreyBg;
    }
  }

  Color getForecastItemContentColor(int code) {
    return Colors.white;
  }
}
