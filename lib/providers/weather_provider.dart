
import 'package:flutter/foundation.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/models/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> refreshAll() async {

    if (_cities.isEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    final cityNames = _cities.map((w) => w.cityName).toList();
    _cities.clear();
    for (final name in cityNames) {
      try {
        final weather = await _service.fetchCurrentWeather(name);
        _cities.add(weather);
      } catch (e) {
        // Skip cities that fail during refresh
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeCity(int index) async {}

  Future<void> addCity(String city) async {
    final normalizedName = city.trim().toLowerCase();
    if (normalizedName.isEmpty) {
      throw WeatherApiException('City name cannot be empty');
    }
    final alreadyExists = _cities.any(
      (w) => w.cityName.toLowerCase() == normalizedName,
    );
    if (alreadyExists) {
      throw WeatherApiException('$city is already in your list');
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final weather = await _service.fetchCurrentWeather(city);
      _cities.add(weather);
      await _saveCities();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadSavedCities() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCities = prefs.getStringList('saved_cities') ?? [];
    if (savedCities.isEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    for (final city in savedCities) {
      try {
        final weather = await _service.fetchCurrentWeather(city);
        _cities.add(weather);
      } catch (e) {
        print('Failed to load $city: $e');
      }
  }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveCities() async {
    final prefs = await SharedPreferences.getInstance();
    final names = _cities.map((w) => w.cityName).toList();
    await prefs.setStringList('saved_cities', names);
  }

  Future<Weather> getForecast(String cityName) async {
    try {
      return await _service.fetchForecast(cityName);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}