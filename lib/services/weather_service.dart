import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.weatherapi.com/v1';
  final String apiKey;
  final http.Client httpClient;

  WeatherService({required this.apiKey, http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();


  Future<Weather> fetchCurrentWeather(String city) async {
    final url = '$_baseUrl/current.json?key=$apiKey&q=$city';
    final response = await httpClient.get(Uri.parse(url), headers: {'Accept': 'application/json'} );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body);
      throw WeatherApiException(error['error']['message']);
    } else {
      throw WeatherApiException('Failed to fetch weather data');
    }
  }

  Future<Weather> fetchForecast(String city) async {
  final url = '$_baseUrl/forecast.json?key=$apiKey&q=$city';
  final response = await httpClient.get(Uri.parse(url), headers: {'Accept': 'application/json'} );

  if (response.statusCode == 200) {
    return Weather.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 400) {
    final error = jsonDecode(response.body);
    throw WeatherApiException(error['error']['message']);
  } else {
    throw WeatherApiException('Failed to fetch forecast data');
  }
}
}

class WeatherApiException implements Exception {
  final String message;
  WeatherApiException(this.message);

  @override
  String toString() => message;
}