import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';

class CityWeatherCard extends StatelessWidget {
  final Weather weather;
  
  const CityWeatherCard({
    super.key,
    required this.weather
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text('weather'),
      ),
    );
   }
}