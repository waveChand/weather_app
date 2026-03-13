import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/models/weather.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen_test.mocks.dart';

@GenerateMocks([WeatherService])
void main() {
  late MockWeatherService mockService;

  final weather = Weather(
    cityName: 'Colombo',
    latitude: 1.0,
    longitude: 2.0,
    country: 'Sri Lanka',
    temperatureC: 20.0,
    conditionText: 'Sunny',
    conditionIconUrl: 'https://example.com/icon.png',
    windKph: 10.0,
    humidity: 50,
    localTime: DateTime(2026, 3, 9, 12, 0),
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockService = MockWeatherService();
  });

  Widget createApp(WeatherProvider provider) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  testWidgets('displays city card after adding a city', (tester) async {
  when(mockService.fetchCurrentWeather('Colombo'))
      .thenAnswer((_) async => weather);

  final provider = WeatherProvider(service: mockService);

  await tester.pumpWidget(createApp(provider));
  await tester.runAsync(() => provider.addCity('Colombo'));
  await tester.pumpAndSettle();
  
  expect(find.text('Colombo'), findsOneWidget);
  expect(find.text('Sri Lanka'), findsOneWidget);
  expect(find.text('Sunny'), findsOneWidget);
});
}