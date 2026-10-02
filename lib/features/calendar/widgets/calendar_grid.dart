import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart' hide normalizeDate;

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/formatters.dart';

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    super.key,
    required this.month,
    required this.results,
    required this.onDayTap,
    required this.onMonthChanged,
  });

  final DateTime month;
  final Map<DateTime, double> results;
  final ValueChanged<DateTime> onDayTap;
  final ValueChanged<DateTime> onMonthChanged;

  @override
  Widget build(BuildContext context) {
    // Tinggi baris mengikuti lebar sel supaya kotak warna besar dan
    // proporsional di semua ukuran layar.
    return LayoutBuilder(builder: (context, constraints) {
      final cellWidth = constraints.maxWidth / 7;
      return _buildCalendar(context, (cellWidth * 1.2).clamp(64.0, 96.0));
    });
  }

  Widget _buildCalendar(BuildContext context, double rowHeight) {
    return TableCalendar<void>(
      locale: 'id_ID',
      firstDay: DateTime(2000),
      lastDay: DateTime(2100, 12, 31),
      focusedDay: month,
      headerVisible: false,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.horizontalSwipe,
      rowHeight: rowHeight,
      daysOfWeekHeight: 28,
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontWeight: FontWeight.w600),
        weekendStyle: TextStyle(fontWeight: FontWeight.w600),
      ),
      // Hari di luar bulan disembunyikan: datanya tidak ikut di-query.
      calendarStyle: const CalendarStyle(outsideDaysVisible: false),
      onPageChanged: (focused) => onMonthChanged(startOfMonth(focused)),
      // table_calendar memberi tanggal UTC - normalizeDate mengubahnya ke lokal.
      onDaySelected: (selected, _) => onDayTap(normalizeDate(selected)),
      // prioritizedBuilder dipakai untuk semua hari (termasuk hari ini,
      // weekend, terpilih) supaya tampilan sel selalu konsisten.
      calendarBuilders: CalendarBuilders(
        prioritizedBuilder: (context, day, focused) {
          if (day.month != focused.month) return const SizedBox.shrink();
          return _cell(context, day, isSameDay(day, DateTime.now()));
        },
      ),
    );
  }

  Widget _cell(BuildContext context, DateTime day, bool isToday) {
    final net = results[normalizeDate(day)];
    final hasColor = net != null && net != 0;
    final fg = hasColor ? Colors.white : Colors.black87;
    // Ukuran eksplisit: tanpa ini Container menyusut selebar teksnya.
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: AppColors.forResult(net),
        borderRadius: BorderRadius.circular(10),
        border: isToday
            ? Border.all(
                color: Theme.of(context).colorScheme.primary, width: 2.5)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${day.day}',
              style: TextStyle(
                  color: fg, fontSize: 16, fontWeight: FontWeight.w700)),
          if (net != null) ...[
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(formatCompactPnl(net),
                  maxLines: 1,
                  style: TextStyle(
                      color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ],
      ),
    );
  }
}
