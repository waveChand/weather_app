import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather.dart';
import 'dart:convert';
import 'dart:io';


void main() async{

  final file = File('test/testData.json');
  final contents = await file.readAsString();
  final json = jsonDecode(contents) as Map<String, dynamic>;

  group('Weather.fromJson', () {
    test('parses current weather correctly', () {

      final weather = Weather.fromJson(json);

      expect(weather.cityName, 'Colombo');
      expect(weather.country, 'Sri Lanka');
      expect(weather.temperatureC, 28.3);
      expect(weather.conditionText, 'Sunny');
      expect(weather.conditionIconUrl,
          '//cdn.weatherapi.com/weather/64x64/day/113.png');
      expect(weather.windKph, 3.6);
      expect(weather.humidity, 79);
    });

    test('parses forecast data when present', () {

      final weather = Weather.fromJson(json);

      expect(weather.forecast, isNotNull);
      expect(weather.forecast!.length, 1);
      expect(weather.forecast![0].maxTempC, 29.4);
      expect(weather.forecast![0].minTempC, 24.6);
      expect(weather.forecast![0].avgTempC, 27.0);
      expect(weather.forecast![0].conditionText, 'Moderate rain');
    });

    test('handles number temperature values from API', () {

      final weather = Weather.fromJson(json);
      expect(weather.temperatureC, 28.3);
    });
  });
}