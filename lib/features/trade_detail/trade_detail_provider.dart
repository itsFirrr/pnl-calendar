import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_utils.dart';
import '../../core/utils/formatters.dart';
import '../../data/repository/trade_repository.dart';
import 'screenshot_storage.dart';

final tradeByIdProvider =
    StreamProvider.autoDispose.family<Trade?, int>((ref, id) {
  return ref.watch(tradeRepositoryProvider).watchTradeById(id);
});

/// [existing] null = mode tambah baru dengan tanggal [initialDate].
typedef TradeFormArgs = ({Trade? existing, DateTime initialDate});

class TradeFormState {
  const TradeFormState({
    required this.isEditing,
    required this.pair,
    required this.direction,
    required this.entryTime,
    required this.exitTime,
    required this.lotSize,
    required this.entryPrice,
    required this.slPrice,
    required this.tpPrice,
    required this.exitPrice,
    required this.resultUsc,
    required this.status,
    required this.entryReason,
    required this.exitReason,
    required this.emotion,
    required this.screenshotPath,
    this.isSaving = false,
    this.formVersion = 0,
  });

  final bool isEditing;
  final String pair;
  final TradeDirection direction;
  final DateTime entryTime;
  final DateTime? exitTime;
  // Field angka disimpan sebagai teks mentah dari input, diparse saat simpan.
  final String lotSize;
  final String entryPrice;
  final String slPrice;
  final String tpPrice;
  final String exitPrice;
  final String resultUsc;
  final TradeStatus status;
  final String entryReason;
  final String exitReason;
  final EmotionState? emotion;
  final String? screenshotPath;
  final bool isSaving;

  /// Naik setiap form di-reset, dipakai sebagai key supaya text field
  /// membaca ulang initialValue.
  final int formVersion;

  factory TradeFormState.newTrade(DateTime date) {
    final now = DateTime.now();
    return TradeFormState(
      isEditing: true,
      pair: '',
      direction: TradeDirection.buy,
      entryTime: DateTime(date.year, date.month, date.day, now.hour, now.minute),
      exitTime: null,
      lotSize: '',
      entryPrice: '',
      slPrice: '',
      tpPrice: '',
      exitPrice: '',
      resultUsc: '',
      status: TradeStatus.closedManual,
      entryReason: '',
      exitReason: '',
      emotion: null,
      screenshotPath: null,
    );
  }

  factory TradeFormState.fromTrade(Trade t, {int formVersion = 0}) =>
      TradeFormState(
        isEditing: false,
        pair: t.pair,
        direction: t.direction,
        entryTime: t.entryTime,
        exitTime: t.exitTime,
        lotSize: numberToText(t.lotSize),
        entryPrice: numberToText(t.entryPrice),
        slPrice: numberToText(t.slPrice),
        tpPrice: numberToText(t.tpPrice),
        exitPrice: numberToText(t.exitPrice),
        resultUsc: numberToText(t.resultUsc),
        status: t.status,
        entryReason: t.entryReason ?? '',
        exitReason: t.exitReason ?? '',
        emotion: t.emotion,
        screenshotPath: t.screenshotPath,
        formVersion: formVersion,
      );

  /// Field nullable memakai closure supaya bisa di-set ke null.
  TradeFormState copyWith({
    bool? isEditing,
    String? pair,
    TradeDirection? direction,
    DateTime? entryTime,
    DateTime? Function()? exitTime,
    String? lotSize,
    String? entryPrice,
    String? slPrice,
    String? tpPrice,
    String? exitPrice,
    String? resultUsc,
    TradeStatus? status,
    String? entryReason,
    String? exitReason,
    EmotionState? Function()? emotion,
    String? Function()? screenshotPath,
    bool? isSaving,
  }) =>
      TradeFormState(
        isEditing: isEditing ?? this.isEditing,
        pair: pair ?? this.pair,
        direction: direction ?? this.direction,
        entryTime: entryTime ?? this.entryTime,
        exitTime: exitTime != null ? exitTime() : this.exitTime,
        lotSize: lotSize ?? this.lotSize,
        entryPrice: entryPrice ?? this.entryPrice,
        slPrice: slPrice ?? this.slPrice,
        tpPrice: tpPrice ?? this.tpPrice,
        exitPrice: exitPrice ?? this.exitPrice,
        resultUsc: resultUsc ?? this.resultUsc,
        status: status ?? this.status,
        entryReason: entryReason ?? this.entryReason,
        exitReason: exitReason ?? this.exitReason,
        emotion: emotion != null ? emotion() : this.emotion,
        screenshotPath:
            screenshotPath != null ? screenshotPath() : this.screenshotPath,
        isSaving: isSaving ?? this.isSaving,
        formVersion: formVersion,
      );
}

class TradeFormNotifier
    extends AutoDisposeFamilyNotifier<TradeFormState, TradeFormArgs> {
  @override
  TradeFormState build(TradeFormArgs arg) => arg.existing == null
      ? TradeFormState.newTrade(arg.initialDate)
      : TradeFormState.fromTrade(arg.existing!);

  TradeRepository get _repo => ref.read(tradeRepositoryProvider);

  void edit(TradeFormState Function(TradeFormState s) change) =>
      state = change(state);

  void startEditing() => state = state.copyWith(isEditing: true);

  /// Batalkan edit: kembalikan semua field ke data tersimpan.
  void cancelEditing() {
    final existing = arg.existing;
    if (existing == null) return;
    state = TradeFormState.fromTrade(existing,
        formVersion: state.formVersion + 1);
  }

  /// Pesan error pertama, atau null kalau form valid.
  String? validate() {
    final s = state;
    if (s.pair.trim().isEmpty) return 'Pair wajib diisi';
    final lot = parseNumber(s.lotSize);
    if (lot == null || lot <= 0) return 'Lot size harus angka lebih dari 0';
    if (parseNumber(s.entryPrice) == null) return 'Harga entry wajib diisi';
    if (parseNumber(s.resultUsc) == null) return 'Hasil P/L wajib diisi';
    for (final (label, text) in [
      ('SL', s.slPrice),
      ('TP', s.tpPrice),
      ('Harga exit', s.exitPrice),
    ]) {
      if (text.trim().isNotEmpty && parseNumber(text) == null) {
        return '$label harus berupa angka';
      }
    }
    if (s.exitTime != null && s.exitTime!.isBefore(s.entryTime)) {
      return 'Waktu exit tidak boleh sebelum waktu entry';
    }
    return null;
  }

  /// Simpan/update. Return true kalau berhasil. Setelah sukses state tidak
  /// diubah lagi: untuk trade lama, stream [tradeByIdProvider] memancarkan
  /// data baru sehingga form dibangun ulang dalam mode lihat.
  Future<bool> save() async {
    if (validate() != null) return false;
    final s = state;
    final existing = arg.existing;
    state = s.copyWith(isSaving: true);
    try {
      String? opt(String text) => text.trim().isEmpty ? null : text.trim();
      final companion = TradesCompanion(
        id: existing == null ? const Value.absent() : Value(existing.id),
        date: Value(normalizeDate(s.entryTime)),
        entryTime: Value(s.entryTime),
        exitTime: Value(s.exitTime),
        pair: Value(s.pair.trim().toUpperCase()),
        direction: Value(s.direction),
        lotSize: Value(parseNumber(s.lotSize)!),
        entryPrice: Value(parseNumber(s.entryPrice)!),
        slPrice: Value(parseNumber(s.slPrice)),
        tpPrice: Value(parseNumber(s.tpPrice)),
        exitPrice: Value(parseNumber(s.exitPrice)),
        resultUsc: Value(parseNumber(s.resultUsc)!),
        status: Value(s.status),
        entryReason: Value(opt(s.entryReason)),
        exitReason: Value(opt(s.exitReason)),
        emotion: Value(s.emotion),
        screenshotPath: Value(s.screenshotPath),
        createdAt:
            existing == null ? const Value.absent() : Value(existing.createdAt),
      );
      if (existing == null) {
        await _repo.insertTrade(companion);
      } else {
        await _repo.updateTrade(companion);
        // Screenshot lama yang diganti/dihapus tidak dipakai lagi.
        if (existing.screenshotPath != s.screenshotPath) {
          await deleteScreenshotFile(existing.screenshotPath);
        }
      }
      return true;
    } catch (_) {
      state = state.copyWith(isSaving: false);
      rethrow;
    }
  }

  Future<void> delete() async {
    final existing = arg.existing;
    if (existing == null) return;
    await _repo.deleteTrade(existing.id);
    await deleteScreenshotFile(existing.screenshotPath);
  }
}

final tradeFormProvider = NotifierProvider.autoDispose
    .family<TradeFormNotifier, TradeFormState, TradeFormArgs>(
        TradeFormNotifier.new);
