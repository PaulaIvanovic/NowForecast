import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // You can customize this
        brightness: Brightness.light, // Or Brightness.dark for dark theme
        fontFamily: 'Roboto', // Example font, ensure it's added if custom
      ),
      debugShowCheckedModeBanner: false, // Removes the debug banner
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _cityName = "Rijeka"; // Default city
  final TextEditingController _searchController = TextEditingController();

  // Placeholder for weather data - you'll replace this with real data
  String _currentTemperature = "23°C";
  String _feelsLikeTemperature = "20°C";
  String _weatherCondition = "Sunny"; // For icon
  String _date = "25.05.2025"; // Example date
  String _dayNight = "DAN"; // Or NOC

  // Placeholder for forecast data
  final List<Map<String, String>> _forecast = [
    {"day": "PON 26.05.", "temp": "22 / 15", "icon": "moon"},
    {"day": "UTO 27.05.", "temp": "23 / 16", "icon": "cloud_rain"},
    {"day": "SRI 28.05.", "temp": "24 / 17", "icon": "cloud_sun_rain"},
    {"day": "ČET 29.05.", "temp": "21 / 14", "icon": "cloud"},
    // Add more forecast items
  ];

  IconData _getWeatherIcon(String condition) {
    // This is a very basic mapping. You'll want a more robust solution.
    // Consider using weather icon packages or mapping API codes.
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'moon': // For night forecast
        return Icons.nightlight_round;
      case 'cloud_rain':
        return Icons.grain; // Placeholder for rain
      case 'cloud_sun_rain':
        return Icons.filter_drama; // Placeholder for mixed
      case 'cloud':
        return Icons.cloud_outlined;
      default:
        return Icons.wb_sunny; // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine background color based on day/night or weather condition
    Color backgroundColor = _dayNight == "DAN" && _weatherCondition == "Sunny"
        ? Colors
              .lightBlue
              .shade200 // Light blue for sunny day
        : Colors.blueGrey.shade300; // Default or night

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Handle drawer open or menu action
            print("Menu button pressed");
          },
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
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
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _cityName = value;
                  // TODO: Fetch weather for new city
                  print("Search submitted: $value");
                  _searchController.clear();
                });
              }
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Handle settings action
              print("Settings button pressed");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Allows scrolling if content overflows
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Location Display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _cityName,
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
                ],
              ),
              const SizedBox(height: 20),

              // Main Weather Icon (Large Sun)
              Icon(
                _getWeatherIcon(
                  _weatherCondition,
                ), // Dynamic based on condition
                size: 150,
                color: _weatherCondition == "Sunny"
                    ? Colors.yellow.shade600
                    : Colors.white,
                shadows: const [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black26,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Day/Night, Feels Like, Date
              Text(
                _dayNight,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Feels like: $_feelsLikeTemperature',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              Text(
                _date,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 30),

              // Forecast List
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.7,
                  ), // Semi-transparent white
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: _forecast.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            _getWeatherIcon(item["icon"]!),
                            color: Colors.blueGrey.shade700,
                            size: 30,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              item["day"]!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            item["temp"]!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20), // Some spacing at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
