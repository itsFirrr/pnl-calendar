import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_utils.dart';
import '../../data/repository/trade_repository.dart';

enum StatsPeriod { week, month, all, custom }

class StatsFilter {
  const StatsFilter(this.period, [this.customRange]);

  final StatsPeriod period;
  final DateTimeRange? customRange;
}

final statsFilterProvider = StateProvider<StatsFilter>(
  (ref) => const StatsFilter(StatsPeriod.month),
);

final statsTradesProvider = StreamProvider<List<Trade>>((ref) {
  final filter = ref.watch(statsFilterProvider);
  final repo = ref.watch(tradeRepositoryProvider);
  final now = DateTime.now();
  switch (filter.period) {
    case StatsPeriod.week:
      final start = startOfWeek(now);
      return repo.watchTradesInRange(start, start.add(const Duration(days: 6)));
    case StatsPeriod.month:
      return repo.watchTradesInRange(startOfMonth(now), endOfMonth(now));
    case StatsPeriod.custom:
      final range = filter.customRange;
      if (range != null) {
        return repo.watchTradesInRange(range.start, range.end);
      }
      return repo.watchAllTrades();
    case StatsPeriod.all:
      return repo.watchAllTrades();
  }
});

final tradeStatsProvider = Provider<AsyncValue<TradeStats>>(
  (ref) => ref.watch(statsTradesProvider).whenData(TradeStats.fromTrades),
);

/// Ringkasan sekelompok trade (per pair, per mood, dst).
class GroupStats<K> {
  GroupStats(this.key);

  final K key;
  int count = 0;
  int wins = 0;
  double total = 0;

  double get winRate => count == 0 ? 0 : wins / count;
}

/// Semua metrik dihitung dari trade yang sudah closed (status != open),
/// karena hasil trade open belum final.
class TradeStats {
  const TradeStats({
    required this.totalTrades,
    required this.openTrades,
    required this.wins,
    required this.losses,
    required this.totalPnl,
    required this.grossProfit,
    required this.grossLoss,
    required this.longestWinStreak,
    required this.longestLossStreak,
    required this.averageRr,
    required this.equity,
    required this.byPair,
    required this.byWeekday,
    required this.byEmotion,
    required this.bestTrade,
    required this.worstTrade,
  });

  final int totalTrades;
  final int openTrades;
  final int wins;
  final int losses;
  final double totalPnl;
  final double grossProfit;

  /// Nilai absolut (positif).
  final double grossLoss;
  final int longestWinStreak;
  final int longestLossStreak;

  /// Null kalau tidak ada trade dengan SL & harga exit.
  final double? averageRr;

  /// Running balance setelah tiap trade, berurutan menurut entryTime.
  final List<double> equity;

  /// Diurutkan dari total P/L terbesar.
  final List<GroupStats<String>> byPair;

  /// Net P/L Senin..Minggu (index 0..6).
  final List<double> byWeekday;

  /// Per mood, urut sesuai enum; key null = mood tidak diisi.
  final List<GroupStats<EmotionState?>> byEmotion;

  final Trade? bestTrade;
  final Trade? worstTrade;

  double? get winRate => totalTrades == 0 ? null : wins / totalTrades;

  /// Null kalau belum ada trade; infinity kalau tidak ada loss sama sekali.
  double? get profitFactor {
    if (grossLoss == 0) return grossProfit > 0 ? double.infinity : null;
    return grossProfit / grossLoss;
  }

  factory TradeStats.fromTrades(List<Trade> trades) {
    final closed = trades.where((t) => t.status != TradeStatus.open).toList()
      ..sort((a, b) => a.entryTime.compareTo(b.entryTime));

    var wins = 0, losses = 0;
    var grossProfit = 0.0, grossLoss = 0.0, balance = 0.0;
    var winStreak = 0, lossStreak = 0, maxWin = 0, maxLoss = 0;
    final equity = <double>[];
    final pairs = <String, GroupStats<String>>{};
    final emotions = <EmotionState?, GroupStats<EmotionState?>>{};
    Trade? best, worst;
    final weekday = List<double>.filled(7, 0);
    final rrs = <double>[];

    for (final t in closed) {
      final r = t.resultUsc;
      if (r > 0) {
        wins++;
        grossProfit += r;
        winStreak++;
        lossStreak = 0;
      } else if (r < 0) {
        losses++;
        grossLoss += -r;
        lossStreak++;
        winStreak = 0;
      } else {
        // Breakeven memutus streak.
        winStreak = 0;
        lossStreak = 0;
      }
      if (winStreak > maxWin) maxWin = winStreak;
      if (lossStreak > maxLoss) maxLoss = lossStreak;

      balance += r;
      equity.add(balance);

      for (final g in [
        pairs.putIfAbsent(t.pair, () => GroupStats(t.pair)),
        emotions.putIfAbsent(t.emotion, () => GroupStats(t.emotion)),
      ]) {
        g.count++;
        g.total += r;
        if (r > 0) g.wins++;
      }

      if (best == null || r > best.resultUsc) best = t;
      if (worst == null || r < worst.resultUsc) worst = t;

      weekday[t.entryTime.weekday - 1] += r;

      // RR realized = jarak exit dari entry dibagi jarak SL dari entry.
      final sl = t.slPrice, exit = t.exitPrice;
      if (sl != null && exit != null) {
        final risk = (t.entryPrice - sl).abs();
        if (risk > 0) {
          final sign = t.direction == TradeDirection.buy ? 1 : -1;
          rrs.add((exit - t.entryPrice) * sign / risk);
        }
      }
    }

    return TradeStats(
      totalTrades: closed.length,
      openTrades: trades.length - closed.length,
      wins: wins,
      losses: losses,
      totalPnl: balance,
      grossProfit: grossProfit,
      grossLoss: grossLoss,
      longestWinStreak: maxWin,
      longestLossStreak: maxLoss,
      averageRr: rrs.isEmpty ? null : rrs.reduce((a, b) => a + b) / rrs.length,
      equity: equity,
      byPair: pairs.values.toList()..sort((a, b) => b.total.compareTo(a.total)),
      byWeekday: weekday,
      byEmotion: [
        for (final e in [...EmotionState.values, null])
          if (emotions[e] != null) emotions[e]!,
      ],
      bestTrade: best,
      worstTrade: worst,
    );
  }
}
