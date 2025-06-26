import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:nowforecast/app/modules/home/controllers/home_controller.dart';
import 'package:nowforecast/widgets/forecast_item_card.dart';
import 'package:nowforecast/app/utils/app_colors.dart';
import 'package:nowforecast/app/data/models/weather_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  // Keep the error builder method - UI-specific utility
  Widget _buildErrorPlaceholder(
    BuildContext context,
    Object exception,
    StackTrace? stackTrace,
    bool isMainImage,
  ) {
    String imageName = "Unknown";
    if (exception.toString().contains("'")) {
      try {
        imageName = exception.toString().split("'")[1];
      } catch (e) {
        // ignore
      }
    }
    print('ERROR loading image: $imageName - $exception ');

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
        backgroundColor: controller.isLoading.value || controller.hasError.value
            ? AppColors.primaryColor
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
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search city',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => Text(
                        controller.cityName.value,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 1.0,
                              color: Colors.black26,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Image.asset(
                    controller.getForecastItemAssetPath(
                      controller.currentWeatherCode.value,
                    ),
                    height: 150,
                    width: 150,
                    errorBuilder:
                        (
                          BuildContext context,
                          Object exception,
                          StackTrace? stackTrace,
                        ) {
                          return _buildErrorPlaceholder(
                            context,
                            exception,
                            stackTrace,
                            true, // For the main image, isMainImage is true
                          );
                        },
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Text(
                    "${controller.dayNight.value} / NOC",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    'Feels like: ${controller.feelsLikeTemperature.value}',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
                Obx(
                  () => Text(
                    controller.date.value,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 30),
                Obx(
                  () => Column(
                    children: controller.forecastDays.map((forecastDay) {
                      final code = forecastDay.day.condition.code; // Get code for each forecast day
                      return ForecastItemCard(
                        // Format day string for forecast card
                        day: DateFormat('EEE dd.MM.').format(DateTime.parse(forecastDay.date)),
                        // Max/Min temperature for forecast card
                        temp: "${forecastDay.day.maxtempC.round()}\u2103 / ${forecastDay.day.mintempC.round()}\u2103",
                        // Icon path based on forecast day's weather code
                        iconPath: controller.getForecastItemAssetPath(code),
                        // Background color based on forecast day's weather code
                        backgroundColor: controller.getForecastItemBackgroundColor(code),
                        // Content color (white)
                        contentColor: controller.getForecastItemContentColor(code),
                        errorBuilder: (context, exception, stackTrace) {
                          return _buildErrorPlaceholder(context, exception, stackTrace, false);
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
