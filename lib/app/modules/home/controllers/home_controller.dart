import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:nowforecast/app/data/models/weather_model.dart';
import 'package:nowforecast/app/data/providers/weather_api_client.dart';
import 'package:nowforecast/app/utils/app_colors.dart';
import 'package:nowforecast/app/modules/settings/controllers/settings_controller.dart';
import 'package:nowforecast/app/routes/app_routes.dart';


class HomeController extends GetxController {
  final WeatherApiClient _weatherApiClient = WeatherApiClient();
  final SettingsController settingsController = Get.find<SettingsController>();

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
  final RxInt currentWeatherCode = RxInt(-1);

  final RxList<ForecastDay> forecastDays = <ForecastDay>[].obs;

  /// Transformed list to display daily forecast based on unit
  final RxList<String> forecastTemperatures = <String>[].obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    Intl.defaultLocale = 'en';
    fetchWeather("Rijeka");

    // Reactively update when temperature unit changes
    ever(settingsController.isCelsius, (_) {
      _updateDisplayedTemperature();
      _updateForecastTemperatures();
    });
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
      weatherConditionText.value = apiResponse.current.condition.text;

      final String dateOnly = apiResponse.location.localtime.split(' ')[0];
      date.value = DateFormat('EEEE dd.MM.yyyy', 'en').format(DateTime.parse(dateOnly));

      dayNight.value = apiResponse.current.isDay == 1 ? "DAN" : "NOĆ";
      currentWeatherCode.value = apiResponse.current.condition.code;

      _updateDisplayedTemperature();

      if (apiResponse.forecast != null && apiResponse.forecast!.forecastday.isNotEmpty) {
        final today = DateTime.parse(apiResponse.location.localtime.split(' ')[0]);

        final filteredForecast = apiResponse.forecast!.forecastday.where((day) => DateTime.parse(day.date).isAfter(today)).toList();

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
        _updateForecastTemperatures();
      } else {
        forecastDays.clear();
        forecastTemperatures.clear();
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Failed to fetch weather data. Please check the city name or your connection.";
      _resetDisplayValuesOnError();
    } finally {
      isLoading.value = false;
    }
  }

  void _updateDisplayedTemperature() {
    final WeatherResponse apiResponse = weatherData.value!;
    final bool isC = settingsController.isCelsius.value;

    final double feelsLike = isC ? apiResponse.current.feelslikeC : (apiResponse.current.feelslikeC * 9 / 5) + 32;
    final unitSymbol = isC ? "\u2103" : "\u2109";
    feelsLikeTemperature.value = "${feelsLike.round()}$unitSymbol";

    final todayForecast = apiResponse.forecast?.forecastday.firstOrNull;
    if (todayForecast != null) {
      final double max = isC ? todayForecast.day.maxtempC : (todayForecast.day.maxtempC * 9 / 5) + 32;
      final double min = isC ? todayForecast.day.mintempC : (todayForecast.day.mintempC * 9 / 5) + 32;
      todayTempRange.value = "${max.round()}$unitSymbol / ${min.round()}$unitSymbol";
    } else {
      todayTempRange.value = "-- / --";
    }
  }

  void _updateForecastTemperatures() {
    final bool isC = settingsController.isCelsius.value;
    final symbol = isC ? "°C" : "°F";

    final List<String> transformedTemps = forecastDays.map((day) {
      final max = isC ? day.day.maxtempC : (day.day.maxtempC * 9 / 5) + 32;
      final min = isC ? day.day.mintempC : (day.day.mintempC * 9 / 5) + 32;
      return "${max.round()}$symbol / ${min.round()}$symbol";
    }).toList();

    forecastTemperatures.assignAll(transformedTemps);
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
    forecastTemperatures.clear();
  }

  void onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      searchController.clear();
      fetchWeather(value);
    }
  }

  void onMenuButtonPressed() {}
  void onSettingsButtonPressed() {
    Get.toNamed(Routes.SETTINGS);
  }

  String getMainWeatherAssetPath(int code) => 'assets/images/$code.png';
  String getForecastItemAssetPath(int code) => 'assets/images/$code.png';

  Color getForecastItemBackgroundColor(int code) {
    return AppColors.forecastColors[code] ?? AppColors.defaultGreyBg;
  }

  Color getForecastItemContentColor(int code) => Colors.white;
}
