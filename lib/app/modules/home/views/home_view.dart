import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:nowforecast/app/modules/home/controllers/home_controller.dart';
import 'package:nowforecast/widgets/forecast_item_card.dart';
import 'package:nowforecast/app/utils/app_colors.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  Widget _buildErrorPlaceholder(BuildContext context, Object exception, StackTrace? stackTrace, bool isMainImage) {
    String imageName = "Unknown";
    if (exception.toString().contains("'")) {
      try {
        imageName = exception.toString().split("'")[1];
      } catch (_) {}
    }
    return Container(
      width: isMainImage ? 150 : 30,
      height: isMainImage ? 150 : 30,
      color: Colors.red.withOpacity(0.3),
      child: Tooltip(
        message: 'Error loading: $imageName\n$exception',
        child: Icon(
          Icons.broken_image,
          color: Colors.red.shade900,
          size: isMainImage ? 50 : 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: controller.isLoading.value || controller.currentWeatherCode.value == -1
            ? AppColors.defaultGreyBg
            : controller.getForecastItemBackgroundColor(controller.currentWeatherCode.value),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: controller.onMenuButtonPressed,
          ),
          title: Container(
            height: 40,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search city',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
              onSubmitted: controller.onSearchSubmitted,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: controller.onSettingsButtonPressed,
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (controller.hasError.value) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      controller.cityName.value,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Image.asset(
                  controller.getMainWeatherAssetPath(controller.currentWeatherCode.value),
                  height: 150,
                  width: 150,
                  errorBuilder: (context, exception, stackTrace) => _buildErrorPlaceholder(context, exception, stackTrace, true),
                ),
                const SizedBox(height: 10),
                Text(
                  "${controller.weatherConditionText.value}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                Text(
                  "${controller.todayTempRange.value}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                Text("Feels like: ${controller.feelsLikeTemperature.value}", style: const TextStyle(fontSize: 16, color: Colors.white70)),
                Text(controller.date.value, style: const TextStyle(fontSize: 16, color: Colors.white70)),
                const SizedBox(height: 30),
                Obx(() {
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.white.withOpacity(0.7)),
                    ),
                    child: Column(
                      children: controller.forecastDays.map((forecastDay) {
                        final code = forecastDay.day.condition.code;
                        return ForecastItemCard(
                          day: (() {
                            final formatted = DateFormat('EEEE dd.MM.', 'en').format(DateTime.parse(forecastDay.date));
                            return formatted[0].toUpperCase() + formatted.substring(1).toLowerCase();
                          })(),
                          temp: "${forecastDay.day.maxtempC.round()}\u2103 / ${forecastDay.day.mintempC.round()}\u2103",
                          iconPath: controller.getForecastItemAssetPath(code),
                          backgroundColor: controller.getForecastItemBackgroundColor(code),
                          contentColor: controller.getForecastItemContentColor(code),
                          errorBuilder: (context, exception, stackTrace) => _buildErrorPlaceholder(context, exception, stackTrace, false),
                        );
                      }).toList(),
                    ),
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }
}
