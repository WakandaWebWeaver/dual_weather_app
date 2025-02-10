import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dual_weather_app/models/weather_model.dart';
import 'dart:ui' as ui;

class WeatherWidget extends StatefulWidget {
  final Weather? weather;
  const WeatherWidget({super.key, required this.weather});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

  List<Color> getGradientColors(String? mainCondition, String? icon) {
    bool isNight = icon?.contains('n') ?? false;

    if (isNight) {
      return [
        const Color(0xFF1a237e),
        const Color(0xFF0d47a1),
        const Color(0xFF000051),
      ];
    }

    switch (mainCondition?.toLowerCase()) {
      case 'clear':
        return [
          const Color(0xFF1E88E5),
          const Color(0xFF64B5F6),
          const Color(0xFF90CAF9),
        ];
      case 'clouds':
        return [
          const Color(0xFF546E7A),
          const Color(0xFF78909C),
          const Color(0xFF90A4AE),
        ];
      case 'rain':
      case 'drizzle':
        return [
          const Color(0xFF1565C0),
          const Color(0xFF1976D2),
          const Color(0xFF1E88E5),
        ];
      case 'thunderstorm':
        return [
          const Color(0xFF311B92),
          const Color(0xFF4527A0),
          const Color(0xFF512DA8),
        ];
      case 'snow':
        return [
          const Color(0xFF78909C),
          const Color(0xFF90A4AE),
          const Color(0xFFB0BEC5),
        ];
      default:
        return [
          const Color(0xFF1E88E5),
          const Color(0xFF64B5F6),
          const Color(0xFF90CAF9),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = getGradientColors(widget.weather?.mainCondition, widget.weather?.icon);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.weather?.cityName ?? 'Loading city...',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Hero(
                          tag: 'weather_animation',
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Lottie.asset(
                              getWeatherAnimation(
                                widget.weather?.mainCondition,
                                widget.weather?.icon,
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${widget.weather?.temperature.round()}°C',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 72,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  '${((widget.weather?.temperature ?? 0) * 9 / 5 + 32).round()}°F',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.weather?.mainCondition.toUpperCase() ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}