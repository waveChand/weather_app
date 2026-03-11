import './forecast_day.dart';

class Weather {
  final String cityName;
  final String country;
  final double latitude;
  final double longitude;
  final DateTime localTime;
  final double temperatureC;
  final String conditionText;
  final String conditionIconUrl;
  final List<ForecastDay>? forecast;

  Weather({
    required this.cityName,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.localTime,
    required this.temperatureC,
    required this.conditionText,
    required this.conditionIconUrl,
    this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {

    final location = json['location'];
    final current = json['current'];
    final condition = current['condition'];

    return Weather(
      cityName: location['name'],
      country: location['country'],
      latitude: location['lat'].toDouble(),
      longitude: location['lon'].toDouble(),
      localTime: DateTime.parse(location['localtime']),
      temperatureC: current['temp_c'].toDouble(),
      conditionText: condition['text'],
      conditionIconUrl: condition['icon'],
      forecast: json['forecast'] != null
          ? (json['forecast']['forecastday'] as List)
              .map((day) => ForecastDay.fromJson(day))
              .toList()
          : [],
    );
  }

  @override
  String toString() {
    return 'Weather(city: $cityName, temperature: $temperatureC, description: $conditionText)';
  }
}
