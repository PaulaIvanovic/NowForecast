import 'dart:convert'; // For jsonDecode
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:nowforecast/app/utils/api_keys.dart'; // File for API key

class WeatherApiClient {
  final String baseUrl = "http://api.weatherapi.com/v1"; // WeatherAPI base URL
  final String apiKey = ApiKeys.weatherApiKey; // Get API key

  Future<Map<String, dynamic>> fetchCurrentWeather(String location) async {
    final uri = Uri.parse('$baseUrl/current.json?key=$apiKey&q=$location&aqi=no');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Handle API errors (e.g., location not found, invalid key)
      throw Exception('Failed to load current weather: ${response.statusCode} ${response.body}');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherForecast(String location, int days) async {
    final uri = Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$location&days=$days&aqi=no&alerts=no');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Handle API errors
      throw Exception('Failed to load weather forecast: ${response.statusCode} ${response.body}');
    }
  }
}
