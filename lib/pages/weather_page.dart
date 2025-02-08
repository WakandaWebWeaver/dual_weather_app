import 'package:dual_weather_app/models/weather_model.dart';
import 'package:dual_weather_app/utils/weather_widget.dart';
import 'package:dual_weather_app/services/weather_service.dart';
import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('8bcf535c6a9af8d675ac579b68f93059');
  Weather? _weather;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeather(); // Fetch default weather on load
  }

  Future<void> _fetchWeather([String? cityName]) async {
    cityName ??= await _weatherService.getCurrentCity();
    print('Fetching weather for: $cityName');

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  void _handleSearch(String cityName) {
    _fetchWeather(cityName);
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter city name...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onSubmitted: _handleSearch,
                autofocus: true,
              )
            : const SizedBox(), // Empty title, no text displayed
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
              });
            },
          ),
        ],
      ),
      body: WeatherWidget(weather: _weather),
    );
  }
}