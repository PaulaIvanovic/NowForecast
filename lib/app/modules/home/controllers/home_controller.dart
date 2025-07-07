import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:nowforecast/app/data/models/weather_model.dart';
import 'package:nowforecast/app/data/providers/weather_api_client.dart';
import 'package:nowforecast/app/utils/app_colors.dart';
import 'package:nowforecast/app/modules/settings/controllers/settings_controller.dart';
import 'package:nowforecast/app/modules/menu/controllers/menu_controller.dart';
import 'package:nowforecast/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final WeatherApiClient _weatherApiClient = WeatherApiClient();
  final SettingsController settingsController = Get.find<SettingsController>();
  final MenuControllerNF menuController = Get.find<MenuControllerNF>();

  final weatherData = Rxn<WeatherResponse>();
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  final cityName = "Loading...".obs;
  final feelsLikeTemperature = "Loading...".obs;
  final weatherConditionText = "Loading...".obs;
  final todayTempRange = "".obs;
  final date = "".obs;
  final currentWeatherCode = (-1).obs;

  final forecastDays = <ForecastDay>[].obs;
  final forecastTemperatures = <String>[].obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    Intl.defaultLocale = 'en';
    fetchWeather("Rijeka");

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
      final raw = await _weatherApiClient.fetchWeatherForecast(city, 8);
      final resp = WeatherResponse.fromJson(raw);
      weatherData.value = resp;

      cityName.value = resp.location.name;
      weatherConditionText.value = resp.current.condition.text;
      final localDate = resp.location.localtime.split(' ')[0];
      date.value = DateFormat('EEEE dd.MM.yyyy', 'en').format(DateTime.parse(localDate));
      currentWeatherCode.value = resp.current.condition.code;

      _updateDisplayedTemperature();

      if (resp.forecast?.forecastday.isNotEmpty ?? false) {
        final today = DateTime.parse(localDate);
        final forecastList = resp.forecast!.forecastday.where((d) => DateTime.parse(d.date).isAfter(today)).toList();

        List<ForecastDay> chosen = [];
        DateTime pointer = today.add(const Duration(days: 1));
        for (int i = 0; i < 7; i++) {
          final match = forecastList.firstWhere((d) => DateTime.parse(d.date).isAtSameMomentAs(pointer), orElse: () => forecastList.last,
          );
          chosen.add(match);
          pointer = pointer.add(const Duration(days: 1));
        }

        forecastDays.assignAll(chosen);
        _updateForecastTemperatures();
      } else {
        forecastDays.clear();
        forecastTemperatures.clear();
      }

    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error fetching weather. Check city or connection.";
      _resetState();
    } finally {
      isLoading.value = false;
    }
  }

  void _updateDisplayedTemperature() {
    final resp = weatherData.value;
    if (resp == null) return;

    final isC = settingsController.isCelsius.value;
    final feels = isC ? resp.current.feelslikeC : resp.current.feelslikeF;
    final symbol = isC ? "°C" : "°F";
    feelsLikeTemperature.value = "${feels.round()}$symbol";

    final todayDay = resp.forecast?.forecastday.firstOrNull;
    if (todayDay != null) {
      final max = isC ? todayDay.day.maxtempC : todayDay.day.maxtempF;
      final min = isC ? todayDay.day.mintempC : todayDay.day.mintempF;
      todayTempRange.value = "${max.round()}$symbol / ${min.round()}$symbol";
    } else {
      todayTempRange.value = "-- / --";
    }
  }

  void _updateForecastTemperatures() {
    final isC = settingsController.isCelsius.value;
    final symbol = isC ? "°C" : "°F";
    final temps = forecastDays.map((d) {
      final max = isC ? d.day.maxtempC : d.day.maxtempF;
      final min = isC ? d.day.mintempC : d.day.mintempF;
      return "${max.round()}$symbol / ${min.round()}$symbol";
    }).toList();
    forecastTemperatures.assignAll(temps);
  }

  void _resetState() {
    cityName.value = "Error";
    feelsLikeTemperature.value = "--";
    weatherConditionText.value = "--";
    todayTempRange.value = "-- / --";
    date.value = "--.--.----";
    currentWeatherCode.value = -1;
    forecastDays.clear();
    forecastTemperatures.clear();
  }

  void onSearchSubmitted(String val) {
    if (val.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      searchController.clear();
      fetchWeather(val);
    }
  }

  void onMenuButtonPressed() => Get.toNamed(Routes.MENU);
  void onSettingsButtonPressed() => Get.toNamed(Routes.SETTINGS);
  void onSaveLocationToggle() {
    final c = cityName.value;
    if (c != "Error" && c != "Loading...") menuController.toggleLocation(c);
  }

  String getMainWeatherAssetPath(int code) => 'assets/images/$code.png';
  String getForecastIconPath(int code) => 'assets/images/$code.png';

  Color getForecastItemBackgroundColor(int code) => AppColors.forecastColors[code] ?? AppColors.defaultGreyBg;
  Color getForecastItemContentColor(int code) => Colors.white;
}
