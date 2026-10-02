import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import 'statistics_provider.dart';
import 'widgets/equity_curve_chart.dart';
import 'widgets/mood_winrate_chart.dart';
import 'widgets/period_summary_card.dart';
import 'widgets/stat_card.dart';
import 'widgets/weekday_bar_chart.dart';

const _periodLabels = {
  StatsPeriod.week: 'Minggu ini',
  StatsPeriod.month: 'Bulan ini',
  StatsPeriod.all: 'Semua',
  StatsPeriod.custom: 'Custom',
};

String _summaryTitle(StatsPeriod period) => switch (period) {
  StatsPeriod.week => 'Rangkuman minggu ini',
  StatsPeriod.month => 'Rangkuman ${formatMonth(DateTime.now())}',
  StatsPeriod.all => 'Rangkuman semua periode',
  StatsPeriod.custom => 'Rangkuman periode custom',
};

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  Future<void> _select(
    BuildContext context,
    WidgetRef ref,
    StatsPeriod period,
  ) async {
    final notifier = ref.read(statsFilterProvider.notifier);
    if (period != StatsPeriod.custom) {
      notifier.state = StatsFilter(period);
      return;
    }
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100, 12, 31),
      initialDateRange:
          notifier.state.customRange ??
          DateTimeRange(start: DateTime(now.year, now.month), end: now),
    );
    // Batal memilih = filter sebelumnya tetap dipakai.
    if (range != null) notifier.state = StatsFilter(StatsPeriod.custom, range);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(statsFilterProvider);
    final statsAsync = ref.watch(tradeStatsProvider);
    final trades = ref.watch(statsTradesProvider).valueOrNull ?? const [];
    final scheme = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final dateFmt = DateFormat('d MMM yyyy', 'id_ID');

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final p in StatsPeriod.values)
                ChoiceChip(
                  label: Text(_periodLabels[p]!),
                  selected: filter.period == p,
                  onSelected: (_) => _select(context, ref, p),
                ),
            ],
          ),
          if (filter.period == StatsPeriod.custom && filter.customRange != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${dateFmt.format(filter.customRange!.start)} - '
                '${dateFmt.format(filter.customRange!.end)}',
              ),
            ),
          const SizedBox(height: 8),
          ...statsAsync.when(
            loading: () => [const Center(child: CircularProgressIndicator())],
            error: (e, _) => [Text('Gagal memuat statistik: $e')],
            data: (s) {
              final pf = s.profitFactor;
              return [
                PeriodSummaryCard(
                  title: _summaryTitle(filter.period),
                  stats: s,
                  trades: trades,
                ),
                const SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.9,
                  children: [
                    StatCard(
                      label: 'Win Rate',
                      value: s.winRate == null
                          ? '-'
                          : formatPercent(s.winRate!),
                    ),
                    StatCard(
                      label: 'Total P/L',
                      value: formatUsc(s.totalPnl),
                      color: AppColors.textForResult(s.totalPnl, scheme),
                    ),
                    StatCard(
                      label: 'Profit Factor',
                      value: pf == null
                          ? '-'
                          : pf.isInfinite
                          ? '∞'
                          : pf.toStringAsFixed(2),
                    ),
                    StatCard(
                      label: 'Streak Win / Loss',
                      value: '${s.longestWinStreak} / ${s.longestLossStreak}',
                    ),
                    StatCard(
                      label: 'Total Trade',
                      value:
                          '${s.totalTrades}'
                          '${s.openTrades > 0 ? ' (+${s.openTrades} open)' : ''}',
                    ),
                    StatCard(
                      label: 'Average RR',
                      value: s.averageRr == null
                          ? '-'
                          : '1 : ${s.averageRr!.toStringAsFixed(2)}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Equity curve', style: titleStyle),
                const SizedBox(height: 8),
                SizedBox(
                  height: 220,
                  child: s.equity.isEmpty
                      ? const Center(child: Text('Belum ada trade closed'))
                      : Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: EquityCurveChart(equity: s.equity),
                        ),
                ),
                const SizedBox(height: 16),
                Text('Per pair', style: titleStyle),
                if (s.byPair.isEmpty) const Text('-'),
                for (final p in s.byPair)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(p.key),
                    subtitle: Text(
                      '${p.count} trade • win rate ${formatPercent(p.winRate)}',
                    ),
                    trailing: Text(
                      formatUsc(p.total),
                      style: TextStyle(
                        color: AppColors.textForResult(p.total, scheme),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text('Per hari dalam seminggu', style: titleStyle),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: WeekdayBarChart(byWeekday: s.byWeekday),
                ),
                const SizedBox(height: 16),
                Text('Win rate per kondisi psikologis', style: titleStyle),
                Text(
                  'Angka dalam kurung = jumlah trade. Tap batang untuk detail.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 220,
                  child: s.byEmotion.isEmpty
                      ? const Center(child: Text('Belum ada trade closed'))
                      : MoodWinRateChart(byEmotion: s.byEmotion),
                ),
                const SizedBox(height: 24),
              ];
            },
          ),
        ],
      ),
    );
  }
}
