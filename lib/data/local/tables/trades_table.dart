import 'package:drift/drift.dart';
import '../enums.dart';

class Trades extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Disimpan terpisah dari entryTime/exitTime (dinormalisasi ke tengah malam)
  // supaya query "semua trade di tanggal X" dan grouping per hari gampang,
  // tanpa perlu extract tanggal dari datetime tiap query.
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get entryTime => dateTime()();
  DateTimeColumn get exitTime => dateTime().nullable()();

  TextColumn get pair => text()();
  TextColumn get direction => textEnum<TradeDirection>()();

  RealColumn get lotSize => real()();
  RealColumn get entryPrice => real()();
  RealColumn get slPrice => real().nullable()();
  RealColumn get tpPrice => real().nullable()();
  RealColumn get exitPrice => real().nullable()();

  // Hasil P/L dalam USC (US Cent). Disimpan manual (bukan dihitung otomatis
  // dari entry/exit price) karena nilai real di broker bisa beda tipis
  // akibat slippage/komisi.
  RealColumn get resultUsc => real()();
  TextColumn get status => textEnum<TradeStatus>()();

  TextColumn get entryReason => text().nullable()();
  TextColumn get exitReason => text().nullable()();
  TextColumn get emotion => textEnum<EmotionState>().nullable()();

  // Path file lokal (bukan blob) - gambar disimpan lewat path_provider,
  // cuma path-nya yang masuk database.
  TextColumn get screenshotPath => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
