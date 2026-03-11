import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/providers/weather_provider.dart';


void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherProvider>(
      
      create: (_) {
        final service = WeatherService(apiKey: "4308d2b6995346e993f21305261003");
        final provider = WeatherProvider(service: service);
        return provider;
      },
      child: MaterialApp(
        title: 'Weather App',
        home: const WeatherScreen(),
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

@override
  void initState() {
    // Fetch weather data when the screen is initialized
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    await provider.fetchWeather('Colombo'); 
    await provider.fetchForecast('Colombo');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          } else {
            return Center(child: Text('Weather data will be displayed here'));
          }
        },
      ),
    );
  }
}