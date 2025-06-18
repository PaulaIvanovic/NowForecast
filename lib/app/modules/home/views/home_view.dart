import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX

import 'package:nowforecast/app/modules/home/controllers/home_controller.dart'; // Import controller
import 'package:nowforecast/widgets/forecast_item_card.dart'; // Import reusable widget

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
        backgroundColor: controller.getForecastItemBackgroundColor(
          controller.weatherCondition.value,
        ),
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
                      controller.weatherCondition.value,
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
                    children: controller.forecast.map((item) {
                      final String iconType = item["icon_type"]!;
                      return ForecastItemCard(
                        day: item["day"]!,
                        temp: item["temp"]!,
                        iconPath: controller.getForecastItemAssetPath(iconType),
                        backgroundColor: controller
                            .getForecastItemBackgroundColor(iconType),
                        contentColor: controller.getForecastItemContentColor(
                          iconType,
                        ),
                        // CORRECTED: Provide a wrapper function here
                        errorBuilder: (context, exception, stackTrace) {
                          return _buildErrorPlaceholder(
                            context,
                            exception,
                            stackTrace,
                            false, // For forecast cards, isMainImage is false
                          );
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
