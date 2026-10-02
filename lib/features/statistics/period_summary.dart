import 'package:intl/intl.dart';

import '../../core/constants/labels.dart';
import '../../core/utils/formatters.dart';
import '../../data/repository/trade_repository.dart';
import 'statistics_provider.dart';

const _weekdayNames = [
  'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu', //
];

/// Mood dengan trade kurang dari ini tidak dijadikan kesimpulan
/// "tertinggi/terendah" supaya 1 trade kebetulan tidak menyesatkan.
const minTradesForMoodInsight = 2;

String moodLabel(EmotionState? e) => e?.label ?? 'Tanpa mood';

/// Kalimat-kalimat rangkuman otomatis dari [s]. Murni dari data, tanpa
/// internet. List kosong kalau belum ada trade closed.
List<String> buildPeriodSummary(TradeStats s) {
  if (s.totalTrades == 0) return const [];
  final lines = <String>[
    '${s.totalTrades} trade closed, win rate ${formatPercent(s.winRate!)}, '
        'total ${formatUsc(s.totalPnl)}.',
  ];

  // Hari dalam seminggu (hanya hari yang nilainya tidak nol).
  final days = [
    for (var i = 0; i < 7; i++)
      if (s.byWeekday[i] != 0) (name: _weekdayNames[i], pnl: s.byWeekday[i]),
  ]..sort((a, b) => b.pnl.compareTo(a.pnl));
  if (days.isNotEmpty) {
    final best = days.first, worst = days.last;
    lines.add(
      days.length == 1
          ? 'Hari trading: ${best.name} (${formatUsc(best.pnl)}).'
          : 'Hari terbaik ${best.name} (${formatUsc(best.pnl)}), '
                'terburuk ${worst.name} (${formatUsc(worst.pnl)}).',
    );
  }

  if (s.byPair.length == 1) {
    lines.add(
      'Pair: ${s.byPair.first.key} (${formatUsc(s.byPair.first.total)}).',
    );
  } else if (s.byPair.length > 1) {
    final best = s.byPair.first, worst = s.byPair.last;
    lines.add(
      'Pair terbaik ${best.key} (${formatUsc(best.total)}), '
      'terburuk ${worst.key} (${formatUsc(worst.total)}).',
    );
  }

  final moods =
      s.byEmotion
          .where((g) => g.key != null && g.count >= minTradesForMoodInsight)
          .toList()
        ..sort((a, b) => b.winRate.compareTo(a.winRate));
  if (moods.length >= 2) {
    final hi = moods.first, lo = moods.last;
    lines.add(
      'Win rate tertinggi saat ${moodLabel(hi.key)} '
      '(${formatPercent(hi.winRate)} dari ${hi.count} trade), '
      'terendah saat ${moodLabel(lo.key)} '
      '(${formatPercent(lo.winRate)} dari ${lo.count} trade).',
    );
  } else if (moods.length == 1) {
    final m = moods.first;
    lines.add(
      'Mood dominan ${moodLabel(m.key)}: win rate '
      '${formatPercent(m.winRate)} dari ${m.count} trade.',
    );
  }

  final dateFmt = DateFormat('d MMM', 'id_ID');
  final best = s.bestTrade, worst = s.worstTrade;
  if (best != null && best.resultUsc > 0) {
    lines.add(
      'Trade terbaik: ${best.pair} ${formatUsc(best.resultUsc)} '
      '(${dateFmt.format(best.date)}).',
    );
  }
  if (worst != null && worst.resultUsc < 0) {
    lines.add(
      'Trade terburuk: ${worst.pair} ${formatUsc(worst.resultUsc)} '
      '(${dateFmt.format(worst.date)}).',
    );
  }

  lines.add(
    'Streak win terpanjang ${s.longestWinStreak}, '
    'streak loss terpanjang ${s.longestLossStreak}.',
  );

  final noMood = s.byEmotion.where((g) => g.key == null).firstOrNull;
  if (noMood != null) {
    lines.add(
      '${noMood.count} trade belum diisi kondisi psikologis - '
      'isi supaya evaluasi mood lebih akurat.',
    );
  }
  return lines;
}
