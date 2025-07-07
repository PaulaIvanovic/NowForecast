import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:nowforecast/app/modules/home/controllers/home_controller.dart';
import 'package:nowforecast/widgets/forecast_item_card.dart';
import 'package:nowforecast/app/utils/app_colors.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  Widget _buildErrorPlaceholder(bool isMain) {
    return Container(
      width: isMain ? 150 : 30,
      height: isMain ? 150 : 30,
      color: Colors.red.withOpacity(0.3),
      child: Icon(Icons.broken_image, color: Colors.red.shade900, size: isMain ? 50 : 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bgColor = controller.isLoading.value || controller.currentWeatherCode.value == -1
          ? AppColors.defaultGreyBg
          : controller.getForecastItemBackgroundColor(controller.currentWeatherCode.value);

      return Scaffold(
        backgroundColor: bgColor,
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
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              onSubmitted: controller.onSearchSubmitted,
            ),
          ),
          actions: [
            Obx(
              () => IconButton(
                icon: Icon(
                  controller.menuController.isSaved(controller.cityName.value) ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: controller.onSaveLocationToggle,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: controller.onSettingsButtonPressed,
            ),
          ],
        ),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : controller.hasError.value
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                      cacheHeight: 150,
                      errorBuilder: (_, __, ___) => _buildErrorPlaceholder(true),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      controller.weatherConditionText.value,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    Text(
                      controller.todayTempRange.value,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    Text("Feels like: ${controller.feelsLikeTemperature.value}", style: const TextStyle(fontSize: 16, color: Colors.white70)),
                    Text(controller.date.value, style: const TextStyle(fontSize: 16, color: Colors.white70)),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white70),
                      ),
                      child: Column(
                        children: List.generate(controller.forecastDays.length, (i) {
                          final d = controller.forecastDays[i];
                          final code = d.day.condition.code;
                          final formatted = DateFormat('EEEE dd.MM.', 'en').format(DateTime.parse(d.date));
                          final dayName = "${formatted[0].toUpperCase()}${formatted.substring(1).toLowerCase()}";

                          return ForecastItemCard(
                            day: dayName,
                            temp: controller.forecastTemperatures[i],
                            iconPath: controller.getForecastIconPath(code),
                            backgroundColor: controller.getForecastItemBackgroundColor(code),
                            contentColor: controller.getForecastItemContentColor(code),
                            errorBuilder: (_, __, ___) => _buildErrorPlaceholder(false),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      );
    });
  }
}
