import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/labels.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/formatters.dart';
import '../../data/repository/trade_repository.dart';
import 'day_detail_provider.dart';

class DayDetailScreen extends ConsumerWidget {
  DayDetailScreen({super.key, required DateTime date})
      : date = normalizeDate(date);

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradesAsync = ref.watch(tradesByDateProvider(date));
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Hari')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.push('/calendar/trade/new?date=${toDateParam(date)}'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Trade'),
      ),
      body: tradesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat data: $e')),
        data: (trades) {
          final net = trades.fold(0.0, (sum, t) => sum + t.resultUsc);
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
            children: [
              Card(
                child: ListTile(
                  title: Text(formatDateLong(date)),
                  subtitle: Text('${trades.length} trade'),
                  trailing: Text(
                    trades.isEmpty ? '-' : formatUsc(net),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textForResult(net, scheme),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (trades.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Belum ada trade di tanggal ini.',
                      textAlign: TextAlign.center),
                ),
              for (final trade in trades) _TradeCard(trade: trade),
            ],
          );
        },
      ),
    );
  }
}

class _TradeCard extends StatelessWidget {
  const _TradeCard({required this.trade});

  final Trade trade;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isBuy = trade.direction == TradeDirection.buy;
    return Card(
      child: ListTile(
        onTap: () => context.push('/calendar/trade/${trade.id}'),
        leading: CircleAvatar(
          backgroundColor:
              isBuy ? scheme.primaryContainer : scheme.tertiaryContainer,
          child: Icon(isBuy ? Icons.trending_up : Icons.trending_down),
        ),
        title: Text(trade.pair,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${trade.direction.label} • '
            '${numberToText(trade.lotSize)} lot • '
            '${formatTime(trade.entryTime)}'
            '${trade.status == TradeStatus.open ? ' • Open' : ''}'),
        trailing: Text(
          formatUsc(trade.resultUsc),
          style: TextStyle(
              color: AppColors.textForResult(trade.resultUsc, scheme),
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
