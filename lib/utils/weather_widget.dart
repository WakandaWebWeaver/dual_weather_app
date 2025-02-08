import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dual_weather_app/models/weather_model.dart';

class WeatherWidget extends StatelessWidget {
  final Weather? weather;

  const WeatherWidget({super.key, required this.weather});

  String getWeatherAnimation(String? mainCondition, String? icon) {
    bool isNight = icon?.contains('n') ?? false;

    switch (mainCondition?.toLowerCase()) {
      case 'clear':
        return isNight ? 'assets/moonlight.json' : 'assets/sunny.json';
      case 'clouds':
        if (icon == '02n' || icon == '03n') {
          return 'assets/cloudymoon.json';
        } else {
          return 'assets/cloudy.json';
        }
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return isNight ? 'assets/nightrain.json' : 'assets/dayrain.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'snow':
        return 'assets/snowy.json';
      case 'wind':
      case 'windy':
        return 'assets/windy.json';
      default:
        return isNight ? 'assets/moonlight.json' : 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_pin, color: Colors.white,),
          Text(
            weather?.cityName ?? 'Loading city...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Lottie.asset(getWeatherAnimation(weather?.mainCondition, weather?.icon)),
          Text(
            '${weather?.temperature.round()}°C / ${((weather?.temperature ?? 0) * 9 / 5 + 32).round()}°F',
            style: const TextStyle(
              color: Color.fromARGB(182, 255, 255, 255),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}