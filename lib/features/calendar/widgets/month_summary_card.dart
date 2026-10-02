import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../calendar_provider.dart';

class MonthSummaryCard extends StatelessWidget {
  const MonthSummaryCard({super.key, required this.summary});

  final MonthSummary? summary;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = summary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            _Item(
              label: 'Total P/L',
              value: s == null ? '-' : formatUsc(s.totalPnl),
              color: s == null
                  ? null
                  : AppColors.textForResult(s.totalPnl, scheme),
            ),
            _Item(
                label: 'Trading Day',
                value: s == null ? '-' : '${s.tradingDays}'),
            _Item(
              label: 'Win Rate',
              value: s?.winRate == null ? '-' : formatPercent(s!.winRate!),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text(label, style: text.labelMedium),
          const SizedBox(height: 4),
          Text(value,
              textAlign: TextAlign.center,
              style: text.titleMedium
                  ?.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
