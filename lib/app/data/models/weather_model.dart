// This file defines the Dart classes that represent the
// JSON data structure received from the WeatherAPI.com.

class WeatherResponse {
  final Location location;
  final Current current;
  final Forecast? forecast; // Nullable if fetching only current weather

  WeatherResponse({required this.location, required this.current, this.forecast});

  // Factory constructor to create a WeatherResponse object from a JSON map
  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
      // Check if 'forecast' key exists and is not null before parsing
      forecast: json['forecast'] != null ? Forecast.fromJson(json['forecast']) : null,
    );
  }
}

class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String localtime; // Example: "2023-11-20 10:30"

  Location({required this.name, required this.region, required this.country, required this.lat, required this.lon, required this.localtime});

  // Factory constructor to create a Location object from a JSON map
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] as String,
      region: json['region'] as String,
      country: json['country'] as String,
      lat: (json['lat'] as num).toDouble(), // Cast to num then to double
      lon: (json['lon'] as num).toDouble(), // Cast to num then to double
      localtime: json['localtime'] as String,
    );
  }
}

class Current {
  final double tempC; // Temperature in Celsius
  final Condition condition;
  final double windKph; // Wind speed in kilometers per hour
  final int humidity; // Humidity percentage
  final double feelslikeC; // Feels like temperature in Celsius
  final int isDay; // 1 = Yes, 0 = No

  Current({
    required this.tempC,
    required this.condition,
    required this.windKph,
    required this.humidity,
    required this.feelslikeC,
    required this.isDay,
  });

  // Factory constructor to create a Current object from a JSON map
  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      tempC: (json['temp_c'] as num).toDouble(),
      condition: Condition.fromJson(json['condition']),
      windKph: (json['wind_kph'] as num).toDouble(),
      humidity: json['humidity'] as int,
      feelslikeC: (json['feelslike_c'] as num).toDouble(),
      isDay: json['is_day'] as int,
    );
  }
}

class Condition {
  final String text; // Text description of weather condition (e.g., "Partly cloudy")
  final String icon; // URL to the weather icon (e.g., "//cdn.weatherapi.com/weather/64x64/day/116.png")
  final int code; // Weather condition code (e.g., 1000 for Clear, Sunny)

  Condition({required this.text, required this.icon, required this.code});

  // Factory constructor to create a Condition object from a JSON map
  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(text: json['text'] as String, icon: json['icon'] as String, code: json['code'] as int);
  }
}

class Forecast {
  final List<ForecastDay> forecastday; // List of daily forecasts

  Forecast({required this.forecastday});

  // Factory constructor to create a Forecast object from a JSON map
  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(forecastday: (json['forecastday'] as List).map((e) => ForecastDay.fromJson(e as Map<String, dynamic>)).toList());
  }
}

class ForecastDay {
  final String date; // Date of the forecast (e.g., "2023-11-20")
  final Day day;
  final Astro astro;
  final List<Hour> hour; // Hourly forecast for this day

  ForecastDay({
    required this.date,
    required this.day, required this.astro, required this.hour,
  });

  // Factory constructor to create a ForecastDay object from a JSON map
  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'] as String,
      day: Day.fromJson(json['day']),
      astro: Astro.fromJson(json['astro']),
      hour: (json['hour'] as List).map((e) => Hour.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Day {
  final double maxtempC; // Maximum temperature in Celsius for the day
  final double mintempC; // Minimum temperature in Celsius for the day
  final Condition condition; // Weather condition for the day

  Day({required this.maxtempC, required this.mintempC, required this.condition,
  });

  // Factory constructor to create a Day object from a JSON map
  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxtempC: (json['maxtemp_c'] as num).toDouble(),
      mintempC: (json['mintemp_c'] as num).toDouble(),
      condition: Condition.fromJson(json['condition']),
    );
  }
}

class Astro {
  final String sunrise; // Sunrise time (e.g., "07:00 AM")
  final String sunset; // Sunset time (e.g., "04:30 PM")

  Astro({required this.sunrise, required this.sunset});

  // Factory constructor to create an Astro object from a JSON map
  factory Astro.fromJson(Map<String, dynamic> json) {
    return Astro(sunrise: json['sunrise'] as String, sunset: json['sunset'] as String);
  }
}

class Hour {
  final String time; // Hourly time (e.g., "2023-11-20 10:00")
  final double tempC; // Temperature in Celsius for the hour
  final Condition condition; // Weather condition for the hour

  Hour({required this.time, required this.tempC, required this.condition});

  // Factory constructor to create an Hour object from a JSON map
  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(time: json['time'] as String, tempC: (json['temp_c'] as num).toDouble(), condition: Condition.fromJson(json['condition']),
    );
  }
}
