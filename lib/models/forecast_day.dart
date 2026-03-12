class ForecastDay {
  final DateTime date;
  final double maxTempC;
  final double minTempC;
  final double avgTempC;
  final String conditionText;
  final String conditionIconUrl;

  ForecastDay({
    required this.date,
    required this.maxTempC,
    required this.minTempC,
    required this.avgTempC,
    required this.conditionText,
    required this.conditionIconUrl,
   });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {

    final day = json['day'];
    final condition = day['condition'];

    return ForecastDay(
      date: DateTime.parse(json['date']),
      maxTempC: day['maxtemp_c'].toDouble(),
      minTempC: day['mintemp_c'].toDouble(),
      avgTempC: day['avgtemp_c'].toDouble(),
      conditionText: condition['text'],
      conditionIconUrl: condition['icon'],
    );
  }
}