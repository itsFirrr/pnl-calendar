import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_utils.dart';
import '../local/database.dart';

export '../local/database.dart' show Trade, TradesCompanion, DailyResult;
export '../local/enums.dart';

/// Pembungkus AppDatabase. Satu-satunya pintu akses database untuk UI
/// (lewat [tradeRepositoryProvider]).
class TradeRepository {
  TradeRepository(this._db);

  final AppDatabase _db;

  Future<int> insertTrade(TradesCompanion trade) =>
      _db.insertTrade(_normalizeDate(trade));

  /// [trade] harus lengkap (termasuk id & createdAt) karena memakai replace.
  Future<bool> updateTrade(TradesCompanion trade) => _db.updateTrade(
      _normalizeDate(trade).copyWith(updatedAt: Value(DateTime.now())));

  Future<int> deleteTrade(int id) => _db.deleteTrade(id);

  Stream<Trade?> watchTradeById(int id) => _db.watchTradeById(id);

  Stream<List<Trade>> watchTradesByDate(DateTime date) =>
      _db.watchTradesByDate(normalizeDate(date));

  Stream<List<DailyResult>> watchDailyNetResults(DateTime start, DateTime end) =>
      _db.watchDailyNetResults(normalizeDate(start), normalizeDate(end));

  Stream<List<Trade>> watchTradesInRange(DateTime start, DateTime end) =>
      _db.watchTradesInRange(normalizeDate(start), normalizeDate(end));

  Stream<List<Trade>> watchAllTrades() => _db.watchAllTrades();

  Future<List<Trade>> getAllTrades() => _db.watchAllTrades().first;

  /// `date` selalu diturunkan dari entryTime lalu dinormalisasi ke tengah
  /// malam, supaya query per tanggal di DAO selalu match.
  TradesCompanion _normalizeDate(TradesCompanion trade) {
    if (trade.entryTime.present) {
      return trade.copyWith(date: Value(normalizeDate(trade.entryTime.value)));
    }
    if (trade.date.present) {
      return trade.copyWith(date: Value(normalizeDate(trade.date.value)));
    }
    return trade;
  }
}

final tradeRepositoryProvider =
    Provider((ref) => TradeRepository(AppDatabase.instance));
