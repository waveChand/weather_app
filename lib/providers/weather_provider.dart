
import 'package:flutter/foundation.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service;
  bool _isLoading = false;
  String? _error;

  // Public getters
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
}