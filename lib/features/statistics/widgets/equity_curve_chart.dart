import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class EquityCurveChart extends StatelessWidget {
  const EquityCurveChart({super.key, required this.equity});

  /// Running balance setelah tiap trade.
  final List<double> equity;

  @override
  Widget build(BuildContext context) {
    // Titik awal 0 supaya kurva berangkat dari saldo nol.
    final spots = [
      const FlSpot(0, 0),
      for (var i = 0; i < equity.length; i++) FlSpot(i + 1.0, equity[i]),
    ];
    final color = equity.isEmpty || equity.last >= 0
        ? AppColors.profit
        : AppColors.loss;
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: color,
            barWidth: 2,
            dotData: FlDotData(show: equity.length <= 30),
            belowBarData: BarAreaData(
              show: true,
              color: color.withValues(alpha: 0.12),
            ),
          ),
        ],
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 44),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
