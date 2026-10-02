import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/repository/trade_repository.dart';

const csvHeader = [
  'id', 'date', 'entry_time', 'exit_time', 'pair', 'direction', 'lot_size',
  'entry_price', 'sl_price', 'tp_price', 'exit_price', 'result_usc', 'status',
  'entry_reason', 'exit_reason', 'emotion', 'screenshot_path', 'created_at',
  'updated_at',
];

/// Pure function supaya bisa dites tanpa file system.
String tradesToCsv(List<Trade> trades) {
  final rows = <List<dynamic>>[
    csvHeader,
    for (final t in trades)
      [
        t.id,
        DateFormat('yyyy-MM-dd').format(t.date),
        t.entryTime.toIso8601String(),
        t.exitTime?.toIso8601String() ?? '',
        t.pair,
        t.direction.name,
        t.lotSize,
        t.entryPrice,
        t.slPrice ?? '',
        t.tpPrice ?? '',
        t.exitPrice ?? '',
        t.resultUsc,
        t.status.name,
        t.entryReason ?? '',
        t.exitReason ?? '',
        t.emotion?.name ?? '',
        t.screenshotPath ?? '',
        t.createdAt.toIso8601String(),
        t.updatedAt.toIso8601String(),
      ],
  ];
  return const ListToCsvConverter().convert(rows);
}

class ExportService {
  ExportService(this._repo);

  final TradeRepository _repo;

  /// Tulis semua trade ke file CSV di folder temporary aplikasi.
  Future<File> exportCsv() async {
    final trades = await _repo.getAllTrades();
    final dir = await getTemporaryDirectory();
    final stamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File(p.join(dir.path, 'kalender_pnl_$stamp.csv'));
    await file.writeAsString(tradesToCsv(trades));
    return file;
  }

  /// Export lalu buka share sheet (simpan ke Drive/Files, kirim, dst).
  Future<int> exportAndShare() async {
    final file = await exportCsv();
    final count = (await _repo.getAllTrades()).length;
    await Share.shareXFiles([XFile(file.path, mimeType: 'text/csv')],
        subject: 'Backup Kalender PNL');
    return count;
  }
}

final exportServiceProvider =
    Provider((ref) => ExportService(ref.watch(tradeRepositoryProvider)));
