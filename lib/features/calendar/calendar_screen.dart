import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/date_utils.dart';
import '../../core/utils/formatters.dart';
import 'calendar_provider.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/month_summary_card.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(focusedMonthProvider);
    // valueOrNull menahan data lama saat ganti bulan, jadi tidak berkedip.
    final results = ref.watch(dailyNetResultsProvider).valueOrNull ?? const {};
    final summary = ref.watch(monthSummaryProvider).valueOrNull;
    final monthNotifier = ref.read(focusedMonthProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Kalender PNL')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah trade',
        onPressed: () => context
            .push('/calendar/trade/new?date=${toDateParam(DateTime.now())}'),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 88),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Bulan sebelumnya',
                icon: const Icon(Icons.chevron_left),
                onPressed: () => monthNotifier.state =
                    DateTime(month.year, month.month - 1),
              ),
              Expanded(
                child: Text(formatMonth(month),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              IconButton(
                tooltip: 'Bulan berikutnya',
                icon: const Icon(Icons.chevron_right),
                onPressed: () => monthNotifier.state =
                    DateTime(month.year, month.month + 1),
              ),
              TextButton(
                onPressed: () =>
                    monthNotifier.state = startOfMonth(DateTime.now()),
                child: const Text('Hari Ini'),
              ),
            ],
          ),
          MonthSummaryCard(summary: summary),
          const SizedBox(height: 8),
          CalendarGrid(
            month: month,
            results: results,
            onMonthChanged: (m) {
              if (m != month) monthNotifier.state = m;
            },
            onDayTap: (day) => context.push('/calendar/day/${toDateParam(day)}'),
          ),
        ],
      ),
    );
  }
}
