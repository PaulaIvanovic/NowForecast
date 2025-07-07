// This file defines the Dart classes that represent the
// JSON data structure received from the WeatherAPI.com.

class WeatherResponse {
  final Location location;
  final Current current;
  final Forecast? forecast; // Nullable if fetching only current weather

  WeatherResponse({required this.location, required this.current, this.forecast});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
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
  final String localtime;

  Location({required this.name, required this.region, required this.country, required this.lat, required this.lon, required this.localtime});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] as String,
      region: json['region'] as String,
      country: json['country'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      localtime: json['localtime'] as String,
    );
  }
}

class Current {
  final double tempC;
  final double tempF; 
  final Condition condition;
  final double windKph;
  final int humidity;
  final double feelslikeC;
  final double feelslikeF;
  final int isDay;

  Current({
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.windKph,
    required this.humidity,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.isDay,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      tempC: (json['temp_c'] as num).toDouble(),
      tempF: (json['temp_f'] as num).toDouble(), // ✅ Added
      condition: Condition.fromJson(json['condition']),
      windKph: (json['wind_kph'] as num).toDouble(),
      humidity: json['humidity'] as int,
      feelslikeC: (json['feelslike_c'] as num).toDouble(),
      feelslikeF: (json['feelslike_f'] as num).toDouble(), // ✅ Added
      isDay: json['is_day'] as int,
    );
  }
}

class Condition {
  final String text;
  final String icon;
  final int code;

  Condition({required this.text, required this.icon, required this.code});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(text: json['text'] as String, icon: json['icon'] as String, code: json['code'] as int);
  }
}

class Forecast {
  final List<ForecastDay> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(forecastday: (json['forecastday'] as List).map((e) => ForecastDay.fromJson(e as Map<String, dynamic>)).toList());
  }
}

class ForecastDay {
  final String date;
  final Day day;
  final Astro astro;
  final List<Hour> hour;

  ForecastDay({
    required this.date,
    required this.day, required this.astro, required this.hour,
  });

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
  final double maxtempC;
  final double mintempC;
  final double maxtempF;
  final double mintempF;
  final Condition condition;

  Day({required this.maxtempC, required this.mintempC, required this.maxtempF, required this.mintempF, required this.condition,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxtempC: (json['maxtemp_c'] as num).toDouble(),
      mintempC: (json['mintemp_c'] as num).toDouble(),
      maxtempF: (json['maxtemp_f'] as num).toDouble(),
      mintempF: (json['mintemp_f'] as num).toDouble(), 
      condition: Condition.fromJson(json['condition']),
    );
  }
}
class Astro {
  final String sunrise;
  final String sunset;

  Astro({required this.sunrise, required this.sunset});

  factory Astro.fromJson(Map<String, dynamic> json) {
    return Astro(sunrise: json['sunrise'] as String, sunset: json['sunset'] as String);
  }
}

class Hour {
  final String time;
  final double tempC;
  final Condition condition;

  Hour({required this.time, required this.tempC, required this.condition});

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(time: json['time'] as String, tempC: (json['temp_c'] as num).toDouble(), condition: Condition.fromJson(json['condition']),
    );
  }
}
