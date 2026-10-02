import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/repository/trade_repository.dart';
import '../../../core/utils/formatters.dart';
import '../period_summary.dart';
import '../statistics_provider.dart';

/// Rangkuman otomatis + kumpulan catatan jurnal pada periode terpilih.
class PeriodSummaryCard extends StatelessWidget {
  const PeriodSummaryCard({
    super.key,
    required this.title,
    required this.stats,
    required this.trades,
  });

  final String title;
  final TradeStats stats;
  final List<Trade> trades;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final lines = buildPeriodSummary(stats);
    final journaled =
        trades
            .where(
              (t) =>
                  (t.entryReason?.isNotEmpty ?? false) ||
                  (t.exitReason?.isNotEmpty ?? false),
            )
            .toList()
          ..sort((a, b) => a.entryTime.compareTo(b.entryTime));

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: text.titleMedium),
            const SizedBox(height: 8),
            if (lines.isEmpty)
              const Text('Belum ada trade closed di periode ini.')
            else
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('•  '),
                      Expanded(child: Text(line)),
                    ],
                  ),
                ),
            Theme(
              // Hilangkan garis bawaan ExpansionTile di dalam Card.
              data: Theme.of(context)
                  .copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('Catatan jurnal (${journaled.length})'),
                children: [
                  if (journaled.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text('Belum ada alasan entry/exit yang ditulis.'),
                    ),
                  for (final t in journaled) _JournalEntry(trade: t),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JournalEntry extends StatelessWidget {
  const _JournalEntry({required this.trade});

  final Trade trade;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final t = trade;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${DateFormat('EEE, d MMM', 'id_ID').format(t.date)} • '
                  '${t.pair} • ${moodLabel(t.emotion)}',
                  style: text.labelLarge,
                ),
              ),
              Text(
                formatUsc(t.resultUsc),
                style: text.labelLarge?.copyWith(
                  color: AppColors.textForResult(t.resultUsc, scheme),
                ),
              ),
            ],
          ),
          if (t.entryReason?.isNotEmpty ?? false)
            Text('Entry: ${t.entryReason}', style: text.bodyMedium),
          if (t.exitReason?.isNotEmpty ?? false)
            Text('Exit: ${t.exitReason}', style: text.bodyMedium),
        ],
      ),
    );
  }
}
