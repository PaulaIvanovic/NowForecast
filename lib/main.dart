import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NowForecast',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey.shade300,
          brightness: Brightness.light,
        ),
        brightness: Brightness.light,
        fontFamily: 'Roboto', //possibly change font family
      ),
      debugShowCheckedModeBanner: false,
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
  String _cityName = "Rijeka"; //this will be based on location or searched city

  final TextEditingController _searchController = TextEditingController();

  //information about current weather
  String _weatherCondition =
      "snow"; // for main display: "sunny_day", "thunderstorm_day", etc.
  String _feelsLikeTemperature = "20\u2103";
  String _date = "25.05.2025";
  String _dayNight = "DAN";

  final List<Map<String, String>> _forecast = [
    {
      "day": "PON 26.05.",
      "temp": "22\u2103 / 15\u2103",
      "icon_type": "moon_stars",
    },
    {"day": "UTO 27.05.", "temp": "20\u2103 / 13\u2103", "icon_type": "snow"},
    {
      "day": "SRI 28.05.",
      "temp": "23\u2103 / 16\u2103",
      "icon_type": "rain_sun",
    },
    {"day": "ČET 29.05.", "temp": "19\u2103 / 14\u2103", "icon_type": "rain"},
    {
      "day": "PET 30.05.",
      "temp": "18\u2103 / 12\u2103",
      "icon_type": "thunderstorm",
    },
    {"day": "SUB 31.05.", "temp": "25\u2103 / 18\u2103", "icon_type": "sun"},
    {"day": "NED 01.06.", "temp": "22\u2103 / 15\u2103", "icon_type": "cloud"},
  ];

  String _getForecastItemAssetPath(String iconType) {
    switch (iconType.toLowerCase()) {
      case 'moon_stars':
        return 'assets/images/moon_stars_forecast.png';
      case 'moon_cloud':
        return 'assets/images/moon_cloudy_forecast.png';
      case 'moon_dark_cloud':
        return 'assets/images/moon_cloud_dark_forecast.png';
      case 'snow':
        return 'assets/images/snow_forecast.png';
      case 'rain_sun':
        return 'assets/images/rain_sun_forecast.png';
      case 'rain':
        return 'assets/images/rain_forecast.png';
      case 'thunderstorm':
        return 'assets/images/thunderstorm_forecast.png';
      case 'sun':
        return 'assets/images/sun_forecast.png';
      case 'cloud':
        return 'assets/images/cloud_forecast.png';
      case 'wind':
        return 'assets/images/wind_day_forecast.png';
      default:
        return 'assets/images/sun_forecast.png';
    }
  }

  Color _getForecastItemBackgroundColor(String iconType) {
    switch (iconType.toLowerCase()) {
      case 'moon_stars':
        return const Color(0xFF114465);
      case 'snow':
        return const Color(0xFF5984BD);
      case 'rain_sun':
        return const Color(0xFF59A7FF);
      case 'rain':
        return const Color(0xFF979BAE);
      case 'thunderstorm':
        return const Color(0xFFA4A397);
      case 'sun':
        return const Color(0xFF5CD9E2);
      case 'cloud':
        return const Color(0xFF59A7FF);
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getForecastItemContentColor(String iconType) {
    switch (iconType.toLowerCase()) {
      case 'moon_stars':
      case 'rain_sun':
      case 'thunderstorm':
      case 'cloud':
      case 'snow':
      case 'rain':
      case 'sun':
      default:
        return Colors.white;
    }
  }

  Widget _buildErrorPlaceholder(
    BuildContext context,
    Object exception,
    StackTrace? stackTrace,
    bool isMainImage,
  ) {
    String imageName = "Unknown";
    if (exception.toString().contains("'")) {
      try {
        imageName = exception.toString().split(
          "'",
        )[1]; // Basic parsing to get asset name
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
    Color overallBackgroundColor = _getForecastItemBackgroundColor(
      _weatherCondition,
    );

    return Scaffold(
      backgroundColor: overallBackgroundColor,
      appBar: AppBar(
        // ... (AppBar code is the same)
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
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
              print("Settings button pressed");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // ... (Location Row is the same)
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
              Image.asset(
                _getForecastItemAssetPath(_weatherCondition),
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
                        true,
                      );
                    },
              ),
              const SizedBox(height: 10),
              // ... (Text info is the same)
              Text(
                "$_dayNight / NOC",
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
              Column(
                children: _forecast.map((item) {
                  final String iconType = item["icon_type"]!;
                  final Color itemBgColor = _getForecastItemBackgroundColor(
                    iconType,
                  );
                  final Color itemContentColor = _getForecastItemContentColor(
                    iconType,
                  );
                  final String itemAssetPath = _getForecastItemAssetPath(
                    iconType,
                  );

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: itemBgColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Color.fromARGB(255, 77, 76, 76),
                        width: 1.0, // Border width of 1.0 pixel
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          itemAssetPath,
                          height: 30,
                          width: 30,
                          //color: itemContentColor,
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
                                  false,
                                );
                              },
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            item["day"]!,
                            style: TextStyle(
                              fontSize: 16,
                              color: itemContentColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          item["temp"]!,
                          style: TextStyle(
                            fontSize: 16,
                            color: itemContentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
