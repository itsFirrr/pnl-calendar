import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/trade_repository.dart';

/// Semua trade di satu tanggal (sudah ternormalisasi).
final tradesByDateProvider =
    StreamProvider.autoDispose.family<List<Trade>, DateTime>((ref, date) {
  return ref.watch(tradeRepositoryProvider).watchTradesByDate(date);
});
