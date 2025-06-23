// Placeholder for weather data models
class WeatherModel {
  final String cityName;
  final String weatherCondition;
  final String feelsLikeTemperature;
  final String date;
  final String dayNight;
  final List<DailyForecast> dailyForecast;

  WeatherModel({
    required this.cityName,
    required this.weatherCondition,
    required this.feelsLikeTemperature,
    required this.date,
    required this.dayNight,
    required this.dailyForecast,
  });

  // Factory constructor for deserializing JSON (future work)
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // Implement JSON parsing logic here
    return WeatherModel(
      cityName: json['city_name'] ?? '',
      weatherCondition: json['weather_condition'] ?? '',
      feelsLikeTemperature: json['feels_like_temp'] ?? '',
      date: json['date'] ?? '',
      dayNight: json['day_night'] ?? '',
      dailyForecast: (json['daily_forecast'] as List)
          .map((e) => DailyForecast.fromJson(e))
          .toList(),
    );
  }
}

class DailyForecast {
  final String day;
  final String temp;
  final String iconType;

  DailyForecast({
    required this.day,
    required this.temp,
    required this.iconType,
  });

  // Factory constructor for deserializing JSON (future work)
  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      day: json['day'] ?? '',
      temp: json['temp'] ?? '',
      iconType: json['icon_type'] ?? '',
    );
  }
}
