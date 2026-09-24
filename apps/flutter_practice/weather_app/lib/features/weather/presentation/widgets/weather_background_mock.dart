import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

class MockWeatherBackground extends StatelessWidget {
  final WeatherEntity? weather;

  const MockWeatherBackground({super.key, this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Text('Mock Weather Background'),
    );
  }
}
