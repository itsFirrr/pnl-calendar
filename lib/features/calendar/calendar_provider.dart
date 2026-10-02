import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_utils.dart';
import '../../data/repository/trade_repository.dart';

/// Bulan yang sedang ditampilkan (selalu tanggal 1).
final focusedMonthProvider =
    StateProvider<DateTime>((ref) => startOfMonth(DateTime.now()));

/// Net P/L per tanggal untuk bulan aktif, key = tanggal ternormalisasi.
final dailyNetResultsProvider = StreamProvider<Map<DateTime, double>>((ref) {
  final month = ref.watch(focusedMonthProvider);
  return ref
      .watch(tradeRepositoryProvider)
      .watchDailyNetResults(startOfMonth(month), endOfMonth(month))
      .map((results) =>
          {for (final r in results) normalizeDate(r.date): r.netResult});
});

class MonthSummary {
  const MonthSummary({
    required this.totalPnl,
    required this.tradingDays,
    required this.winRate,
  });

  final double totalPnl;
  final int tradingDays;

  /// Persentase trade closed yang profit; null kalau belum ada trade closed.
  final double? winRate;

  factory MonthSummary.fromTrades(List<Trade> trades) {
    final closed = trades.where((t) => t.status != TradeStatus.open).toList();
    final wins = closed.where((t) => t.resultUsc > 0).length;
    return MonthSummary(
      totalPnl: trades.fold(0.0, (sum, t) => sum + t.resultUsc),
      tradingDays: trades.map((t) => normalizeDate(t.date)).toSet().length,
      winRate: closed.isEmpty ? null : wins / closed.length,
    );
  }
}

final monthSummaryProvider = StreamProvider<MonthSummary>((ref) {
  final month = ref.watch(focusedMonthProvider);
  return ref
      .watch(tradeRepositoryProvider)
      .watchTradesInRange(startOfMonth(month), endOfMonth(month))
      .map(MonthSummary.fromTrades);
});
