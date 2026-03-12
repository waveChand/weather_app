
import 'package:flutter/foundation.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/models/weather.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service;
  final List<Weather> _cities = [];
  bool _isLoading = false;
  String? _error;

  // Public getters
  List<Weather> get cities => List.unmodifiable(_cities);
  bool get isLoading => _isLoading;
  String? get error => _error;

  WeatherProvider({required WeatherService service}) : _service = service;

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final weatherData = await _service.fetchCurrentWeather(city);
      print(  'Fetched weather data: $weatherData' );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchForecast(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final weatherData = await _service.fetchForecast(city);
      print(  'Fetched forecast data: $weatherData' );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAll() async {}

  Future<void> removeCity(int index) async {}

  Future<void> addCity(String city) async {}

  Future<void> loadSavedCities() async {}
}