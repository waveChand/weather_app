import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';

class ForecastScreen extends StatelessWidget {
  final Weather weather;
  const ForecastScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forecast'),
      ),
      body: ListView.builder(
        itemCount: weather.forecast?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Hello'),
          );
        },
      ),
    );
  }
}