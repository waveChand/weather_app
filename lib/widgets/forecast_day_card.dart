import 'package:flutter/material.dart';
import '../models/forecast_day.dart';
import 'package:intl/intl.dart';

class ForecastDayCard extends StatelessWidget {
  final ForecastDay day;

  const ForecastDayCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isToday = _isToday(day.date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              isToday ? 'Today' : DateFormat('EEEE').format(day.date),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat('MMM d, yyyy').format(day.date),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.outline,
              ),
            ),

            const SizedBox(height: 20),

            Image.network(
              day.conditionIconUrl,
              width: 80,
              height: 80,
              errorBuilder: (_, _, _) =>
                  Icon(Icons.cloud, size: 80, color: colors.outline),
            ),

            const SizedBox(height: 8),

            Text(
              day.conditionText,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Divider(color: colors.outlineVariant),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DetailItem(
                  icon: Icons.thermostat,
                  label: 'Min Temp',
                  value: '${day.minTempC}°C',
                  color: Colors.blueAccent,
                ),
                _DetailItem(
                  icon: Icons.thermostat,
                  label: 'Avg Temp',
                  value: '${day.avgTempC}°C',
                  color: Colors.blueAccent,
                ),
                _DetailItem(
                  icon: Icons.thermostat,
                  label: 'Max Temp',
                  value: '${day.maxTempC}°C',
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}