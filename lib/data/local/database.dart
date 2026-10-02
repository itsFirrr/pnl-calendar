import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables/trades_table.dart';
import 'enums.dart';

part 'database.g.dart';

class DailyResult {
  final DateTime date;
  final double netResult;
  DailyResult({required this.date, required this.netResult});
}

@DriftDatabase(tables: [Trades])
class AppDatabase extends _$AppDatabase {
  // Executor opsional supaya test bisa memakai database in-memory.
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  // Singleton sederhana - cukup untuk kebutuhan single-user, tanpa DI framework.
  static final AppDatabase instance = AppDatabase();

  @override
  int get schemaVersion => 1;

  // ---------- CRUD dasar ----------
  Future<int> insertTrade(TradesCompanion trade) => into(trades).insert(trade);

  Future<bool> updateTrade(TradesCompanion trade) => update(trades).replace(trade);

  Future<int> deleteTrade(int id) =>
      (delete(trades)..where((t) => t.id.equals(id))).go();

  // ---------- Query per layar ----------

  /// Semua trade pada satu tanggal spesifik - dipakai di Layar Detail Hari.
  /// [date] harus sudah dinormalisasi ke tengah malam (tanpa jam/menit).
  Stream<List<Trade>> watchTradesByDate(DateTime date) {
    return (select(trades)
          ..where((t) => t.date.equals(date))
          ..orderBy([(t) => OrderingTerm.asc(t.entryTime)]))
        .watch();
  }

  /// Net P/L per tanggal dalam suatu rentang - dipakai untuk mewarnai
  /// kalender. Satu query, satu kali jalan per bulan yang sedang dibuka.
  Stream<List<DailyResult>> watchDailyNetResults(DateTime start, DateTime end) {
    final query = (selectOnly(trades)
      ..addColumns([trades.date, trades.resultUsc.sum()])
      ..where(trades.date.isBetweenValues(start, end))
      ..groupBy([trades.date]));

    return query.watch().map((rows) => rows.map((row) {
          return DailyResult(
            date: row.read(trades.date)!,
            netResult: row.read(trades.resultUsc.sum()) ?? 0.0,
          );
        }).toList());
  }

  /// Semua trade dalam rentang tanggal - dipakai di Layar Statistik
  /// (equity curve, breakdown per pair, breakdown per hari dalam seminggu).
  Stream<List<Trade>> watchTradesInRange(DateTime start, DateTime end) {
    return (select(trades)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.asc(t.entryTime)]))
        .watch();
  }

  /// Satu trade berdasarkan id - dipakai di Layar Detail/Edit Trade.
  Stream<Trade?> watchTradeById(int id) {
    return (select(trades)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  Stream<List<Trade>> watchAllTrades() {
    return (select(trades)
          ..orderBy([(t) => OrderingTerm.asc(t.entryTime)]))
        .watch();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kalender_pnl.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
