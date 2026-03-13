import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/services/weather_service.dart';
import 'dart:io';
import 'weather_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  late MockClient mockClient;
  late WeatherService service;
  final file = File('test/testData.json');
  final contents = await file.readAsString();
  final json = jsonDecode(contents) as Map<String, dynamic>;


  setUp(() {
    mockClient = MockClient();
    service = WeatherService(apiKey: 'test_key', httpClient: mockClient);
  });

  group('getCurrentWeather', () {
    final successResponse = jsonEncode(json);

    test('returns Weather on 200 response', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(successResponse, 200),
      );

      final weather = await service.fetchCurrentWeather('Colombo');

      expect(weather.cityName, 'Colombo');
      expect(weather.country, 'Sri Lanka');
      expect(weather.temperatureC, 28.3);
      expect(weather.humidity, 79);
    });

    test('throws WeatherApiException on 400 response', () async {
      final errorResponse = jsonEncode({
        'error': {'message': 'No matching location found.'},
      });

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(errorResponse, 400),
      );

      expect(
        () => service.fetchCurrentWeather('xyznonexistent'),
        throwsA(isA<WeatherApiException>()),
      );
    });

    test('throws WeatherApiException on 500 server error', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response('Internal Server Error', 500),
      );

      expect(
        () => service.fetchCurrentWeather('London'),
        throwsA(isA<WeatherApiException>()),
      );
    });
  });

  group('getForecast', () {
    test('returns Weather with forecast data on 200', () async {
      final forecastResponse = jsonEncode(json);

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(forecastResponse, 200),
      );

      final weather = await service.fetchForecast('Colombo');

      expect(weather.forecast, isNotNull);
      expect(weather.forecast![0].conditionText, 'Moderate rain');
    });
  });
}