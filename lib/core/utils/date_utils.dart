import 'package:intl/intl.dart';

/// Buang jam/menit/detik - semua field `date` di tabel Trades memakai ini.
DateTime normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime startOfMonth(DateTime d) => DateTime(d.year, d.month);

/// Hari terakhir bulan (tengah malam), cocok untuk query inklusif.
DateTime endOfMonth(DateTime d) => DateTime(d.year, d.month + 1, 0);

/// Senin di minggu yang sama.
DateTime startOfWeek(DateTime d) =>
    normalizeDate(d).subtract(Duration(days: d.weekday - DateTime.monday));

/// Format tanggal untuk parameter route (`yyyy-MM-dd`).
String toDateParam(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
