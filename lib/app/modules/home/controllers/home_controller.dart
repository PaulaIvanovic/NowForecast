import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:nowforecast/app/data/models/weather_model.dart';
import 'package:nowforecast/app/data/providers/weather_api_client.dart';
import 'package:nowforecast/app/utils/app_colors.dart';

class HomeController extends GetxController {
  final WeatherApiClient _weatherApiClient = WeatherApiClient();

  final Rx<WeatherResponse?> weatherData = Rx<WeatherResponse?>(null);
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString cityName = "Loading...".obs;
  final RxString feelsLikeTemperature = "Loading...".obs;
  final RxString weatherConditionText = "Loading...".obs;
  final RxString todayTempRange = "".obs;
  final RxString date = "".obs;
  final RxString dayNight = "".obs;
  final RxInt currentWeatherCode = RxInt(-1); // Use -1 to clearly differentiate initial state

  final RxList<ForecastDay> forecastDays = <ForecastDay>[].obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    Intl.defaultLocale = 'en';
    fetchWeather("Rijeka");
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchWeather(String city) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final Map<String, dynamic> rawWeatherData = await _weatherApiClient.fetchWeatherForecast(city, 8);
      final WeatherResponse apiResponse = WeatherResponse.fromJson(rawWeatherData);

      weatherData.value = apiResponse;

      cityName.value = apiResponse.location.name;
      feelsLikeTemperature.value = "${apiResponse.current.feelslikeC.round()}\u2103";
      weatherConditionText.value = apiResponse.current.condition.text;

      final String dateOnly = apiResponse.location.localtime.split(' ')[0];
      date.value = DateFormat('EEEE dd.MM.yyyy', 'en').format(DateTime.parse(dateOnly));


      dayNight.value = apiResponse.current.isDay == 1 ? "DAN" : "NOĆ";
      currentWeatherCode.value = apiResponse.current.condition.code;

      final todayForecast = apiResponse.forecast?.forecastday.firstOrNull;
      if (todayForecast != null) {
        final max = todayForecast.day.maxtempC.round();
        final min = todayForecast.day.mintempC.round();
        todayTempRange.value = "$max°C / $min°C";
      } else {
        todayTempRange.value = "-- / --";
      }

      if (apiResponse.forecast != null && apiResponse.forecast!.forecastday.isNotEmpty) {
        final today = DateTime.parse(apiResponse.location.localtime.split(' ')[0]);

        // Filter out today, start from tomorrow
        final filteredForecast = apiResponse.forecast!.forecastday.where((day) => DateTime.parse(day.date).isAfter(today)).toList();

        // Get the next 7 days from tomorrow
        List<ForecastDay> finalForecast = [];
        final tomorrow = today.add(const Duration(days: 1));
        for (int i = 0; i < 7; i++) {
          final targetDate = tomorrow.add(Duration(days: i));

          final forecastForTargetDate = filteredForecast.firstWhere(
            (forecastDay) => DateTime.parse(forecastDay.date).isAtSameMomentAs(targetDate),
            orElse: () => filteredForecast.last,
          );

          finalForecast.add(forecastForTargetDate);
        }

        forecastDays.assignAll(finalForecast);
      } else {
        forecastDays.clear();
      }

    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Failed to fetch weather data. Please check the city name or your connection.";
      _resetDisplayValuesOnError();
    } finally {
      isLoading.value = false;
    }
  }

  void _resetDisplayValuesOnError() {
    cityName.value = "Error";
    feelsLikeTemperature.value = "--";
    weatherConditionText.value = "Could not fetch data";
    todayTempRange.value = "-- / --";
    date.value = "--.--.----";
    dayNight.value = "";
    currentWeatherCode.value = -1;
    forecastDays.clear();
  }

  void onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      searchController.clear();
      fetchWeather(value);
    }
  }

  void onMenuButtonPressed() {}
  void onSettingsButtonPressed() {}

  String getMainWeatherAssetPath(int code) => 'assets/images/$code.png';
  String getForecastItemAssetPath(int code) => 'assets/images/$code.png';

  Color getForecastItemBackgroundColor(int code) {
    return AppColors.forecastColors[code] ?? AppColors.defaultGreyBg;
  }

  Color getForecastItemContentColor(int code) => Colors.white;
}
