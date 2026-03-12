import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/widgets/forecast_day_card.dart';

class ForecastScreen extends StatefulWidget {
  final Weather weather;
  const ForecastScreen({super.key, required this.weather});
  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}
class _ForecastScreenState extends State<ForecastScreen> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final forecast = widget.weather.forecast ?? [];
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.weather.cityName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                widget.weather.country,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.outline,
                    ),
              ),
            ),
          ),
        ],
      ),
      body: forecast.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, size: 64, color: colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    'No forecast data available',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                _buildCurrentWeatherHeader(context),
                const SizedBox(height: 8),
                _buildForecastLabel(context),
                const SizedBox(height: 8),
                Expanded(
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.85),
                    itemCount: forecast.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return ForecastDayCard(day: forecast[index]);
                    },
                  ),
                ),
                _buildPageIndicator(context, forecast.length),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
  Widget _buildCurrentWeatherHeader(BuildContext context) {
    final weather = widget.weather;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.network(
            weather.conditionIconUrl,
            width: 64,
            height: 64,
            errorBuilder: (_, __, ___) => Icon(
              Icons.cloud,
              size: 64,
              color: colorScheme.outline,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Now',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.outline,
                      ),
                ),
                Text(
                  '${weather.temperatureC.round()}°C',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  weather.conditionText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.water_drop, size: 16, color: colorScheme.outline),
                  const SizedBox(width: 4),
                  Text(
                    '${weather.humidity}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.air, size: 16, color: colorScheme.outline),
                  const SizedBox(width: 4),
                  Text(
                    '${weather.windKph.round()} km/h',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildForecastLabel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            'Forecast',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
  Widget _buildPageIndicator(BuildContext context, int count) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          final isActive = index == _currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}