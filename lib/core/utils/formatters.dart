import 'package:intl/intl.dart';

final _amount = NumberFormat('#,##0.##', 'en_US');
final _compact = NumberFormat('0.#', 'en_US');

/// Contoh: "+15.5 USC", "-8 USC".
String formatUsc(double v) => '${v > 0 ? '+' : ''}${_amount.format(v)} USC';

/// Angka singkat untuk cell kalender, contoh "+15" / "-8.5".
String formatCompactPnl(double v) => '${v > 0 ? '+' : ''}${_compact.format(v)}';

String formatPercent(double v) => '${(v * 100).toStringAsFixed(1)}%';

String formatMonth(DateTime d) => DateFormat('MMMM yyyy', 'id_ID').format(d);

String formatDateLong(DateTime d) =>
    DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(d);

String formatDateTime(DateTime d) =>
    DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(d);

String formatTime(DateTime d) => DateFormat('HH:mm').format(d);

/// Angka untuk diisi ulang ke text field (tanpa ".0" di belakang).
String numberToText(double? v) {
  if (v == null) return '';
  return v == v.truncateToDouble() ? v.toInt().toString() : v.toString();
}

/// Terima koma maupun titik sebagai pemisah desimal.
double? parseNumber(String text) =>
    double.tryParse(text.trim().replaceAll(',', '.'));
