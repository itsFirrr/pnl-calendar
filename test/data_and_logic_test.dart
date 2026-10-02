import 'package:csv/csv.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kalender_pnl/data/local/database.dart';
import 'package:kalender_pnl/data/repository/trade_repository.dart';
import 'package:kalender_pnl/features/calendar/calendar_provider.dart';
import 'package:kalender_pnl/features/settings/export_service.dart';
import 'package:kalender_pnl/features/statistics/period_summary.dart';
import 'package:kalender_pnl/features/statistics/statistics_provider.dart';

TradesCompanion trade(DateTime entry, double result,
        {String pair = 'XAUUSD',
        TradeStatus status = TradeStatus.closedManual,
        TradeDirection dir = TradeDirection.buy,
        double entryPrice = 100,
        double? sl,
        double? exit,
        EmotionState? emotion}) =>
    TradesCompanion.insert(
      date: entry, // sengaja tidak dinormalisasi: repository yang mengurus
      entryTime: entry,
      pair: pair,
      direction: dir,
      lotSize: 0.01,
      entryPrice: entryPrice,
      resultUsc: result,
      status: status,
      slPrice: Value(sl),
      exitPrice: Value(exit),
      emotion: Value(emotion),
    );

void main() {
  late AppDatabase db;
  late TradeRepository repo;

  setUpAll(() => initializeDateFormatting('id_ID'));

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = TradeRepository(db);
  });
  tearDown(() => db.close());

  test('date dinormalisasi & net harian dijumlahkan per tanggal', () async {
    await repo.insertTrade(trade(DateTime(2026, 10, 1, 9, 30), 15));
    await repo.insertTrade(trade(DateTime(2026, 10, 1, 14, 5), -20));
    await repo.insertTrade(trade(DateTime(2026, 10, 2, 8), 7.5));
    await repo.insertTrade(trade(DateTime(2026, 11, 1, 8), 99)); // bulan lain

    final daily = await repo
        .watchDailyNetResults(DateTime(2026, 10, 1), DateTime(2026, 10, 31))
        .first;
    final map = {for (final d in daily) d.date: d.netResult};
    expect(map, {DateTime(2026, 10, 1): -5.0, DateTime(2026, 10, 2): 7.5});

    final byDate = await repo.watchTradesByDate(DateTime(2026, 10, 1, 23)).first;
    expect(byDate.length, 2);
    expect(byDate.first.date, DateTime(2026, 10, 1));
  });

  test('update, delete, dan stream reaktif', () async {
    final id = await repo.insertTrade(trade(DateTime(2026, 10, 1, 9), 10));
    final stream = repo.watchTradeById(id);
    final t = (await stream.first)!;

    await repo.updateTrade(t
        .copyWith(resultUsc: -3, entryTime: DateTime(2026, 10, 3, 10))
        .toCompanion(true));
    final updated = (await repo.watchTradeById(id).first)!;
    expect(updated.resultUsc, -3);
    expect(updated.date, DateTime(2026, 10, 3));
    expect(updated.createdAt, t.createdAt);

    await repo.deleteTrade(id);
    expect(await repo.watchTradeById(id).first, isNull);
  });

  test('MonthSummary', () async {
    await repo.insertTrade(trade(DateTime(2026, 10, 1, 9), 10));
    await repo.insertTrade(trade(DateTime(2026, 10, 1, 10), -4));
    await repo.insertTrade(trade(DateTime(2026, 10, 5, 10), 2,
        status: TradeStatus.open));
    final s = MonthSummary.fromTrades(await repo.getAllTrades());
    expect(s.totalPnl, 8);
    expect(s.tradingDays, 2);
    expect(s.winRate, 0.5);
  });

  test('TradeStats', () async {
    final base = DateTime(2026, 9, 28); // Senin
    final results = [10.0, 5.0, -4.0, -6.0, -2.0, 8.0];
    for (var i = 0; i < results.length; i++) {
      await repo.insertTrade(trade(base.add(Duration(days: i, hours: 9)),
          results[i], pair: i.isEven ? 'XAUUSD' : 'EURUSD'));
    }
    // RR: buy entry 100, sl 90, exit 120 -> 2R
    await repo.insertTrade(trade(base.add(const Duration(hours: 1)), 0,
        sl: 90, exit: 120));
    await repo.insertTrade(trade(base, 50, status: TradeStatus.open));

    final s = TradeStats.fromTrades(await repo.getAllTrades());
    expect(s.totalTrades, 7);
    expect(s.openTrades, 1);
    expect(s.wins, 3);
    expect(s.losses, 3);
    expect(s.totalPnl, 11);
    expect(s.profitFactor, closeTo(23 / 12, 1e-9));
    expect(s.longestWinStreak, 2);
    expect(s.longestLossStreak, 3);
    expect(s.averageRr, 2);
    expect(s.equity.last, 11);
    expect(s.byWeekday[0], 10); // Senin
    expect(s.byPair.first.key, 'EURUSD'); // 7 vs 4
  });

  test('export CSV berisi semua trade', () async {
    await repo.insertTrade(trade(DateTime(2026, 10, 1, 9), 10));
    await repo.insertTrade(trade(DateTime(2026, 10, 2, 9), -5.5, pair: 'A,B'));
    final csv = tradesToCsv(await repo.getAllTrades());
    final rows = const CsvToListConverter(eol: '\r\n').convert(csv);
    expect(rows.length, 3);
    expect(rows.first, csvHeader);
    expect(rows[2][4], 'A,B');
    expect(rows[2][11], -5.5);
  });

  test('win rate per mood & rangkuman periode', () async {
    final d = DateTime(2026, 10, 6, 9); // Selasa
    await repo.insertTrade(trade(d, 20, emotion: EmotionState.disciplined));
    await repo.insertTrade(trade(d, 10, emotion: EmotionState.disciplined));
    await repo.insertTrade(trade(d, -5, emotion: EmotionState.disciplined));
    await repo.insertTrade(trade(d, -30, emotion: EmotionState.fomo));
    await repo.insertTrade(trade(d, -10, emotion: EmotionState.fomo));
    await repo.insertTrade(trade(d, 4, emotion: EmotionState.tilt)); // 1 trade
    await repo.insertTrade(trade(d, 1));

    final s = TradeStats.fromTrades(await repo.getAllTrades());
    // Urut sesuai enum, "tanpa mood" paling akhir.
    expect(s.byEmotion.map((g) => g.key), [
      EmotionState.fomo,
      EmotionState.disciplined,
      EmotionState.tilt,
      null,
    ]);
    final disciplined = s.byEmotion[1];
    expect(disciplined.count, 3);
    expect(disciplined.winRate, closeTo(2 / 3, 1e-9));
    expect(s.byEmotion[0].winRate, 0);
    expect(s.bestTrade!.resultUsc, 20);
    expect(s.worstTrade!.resultUsc, -30);

    final summary = buildPeriodSummary(s);
    // Tilt (1 trade) tidak dijadikan kesimpulan.
    expect(summary, contains(contains('tertinggi saat Disiplin')));
    expect(summary, contains(contains('terendah saat FOMO')));
    expect(summary, contains(contains('1 trade belum diisi kondisi psikologis')));
    expect(buildPeriodSummary(TradeStats.fromTrades(const [])), isEmpty);
  });
}
