import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/repository/trade_repository.dart';
import '../period_summary.dart';
import '../statistics_provider.dart';

/// Win rate per kondisi psikologis. Hijau >= 50%, merah < 50%.
class MoodWinRateChart extends StatelessWidget {
  const MoodWinRateChart({super.key, required this.byEmotion});

  final List<GroupStats<EmotionState?>> byEmotion;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 100,
        barGroups: [
          for (var i = 0; i < byEmotion.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: byEmotion[i].winRate * 100,
                  width: 18,
                  color: byEmotion[i].winRate >= 0.5
                      ? AppColors.profit
                      : AppColors.loss,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
        ],
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, _, rod, _) {
              final g = byEmotion[group.x];
              return BarTooltipItem(
                '${moodLabel(g.key)}\n${rod.toY.toStringAsFixed(0)}% '
                '(${g.wins}/${g.count})',
                const TextStyle(color: Colors.white, fontSize: 12),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              interval: 25,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}%',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              getTitlesWidget: (value, meta) {
                final g = byEmotion[value.toInt()];
                // Jumlah trade ditampilkan supaya win rate dari 1-2 trade
                // tidak terbaca sebagai pola.
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${moodLabel(g.key)}\n(${g.count})',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(
          drawVerticalLine: false,
          horizontalInterval: 25,
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
