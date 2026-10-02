import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kalender_pnl/app.dart';
import 'package:kalender_pnl/core/theme/app_colors.dart';
import 'package:kalender_pnl/data/local/database.dart';
import 'package:kalender_pnl/data/repository/trade_repository.dart';

/// Pengganti pumpAndSettle: stream Drift menjadwalkan timer 0 ms terus-menerus,
/// jadi cukup pump beberapa frame untuk menyelesaikan animasi transisi.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('alur tab, kalender -> detail hari -> tambah trade', (tester) async {
    await tester.runAsync(() => initializeDateFormatting('id_ID'));
    // Ukuran layar HP (~432x960 dp).
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final db = AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(ProviderScope(
      overrides: [tradeRepositoryProvider.overrideWithValue(TradeRepository(db))],
      child: const KalenderPnlApp(),
    ));
    await settle(tester);
    expect(find.text('Kalender PNL'), findsOneWidget);

    // Pindah tab.
    await tester.tap(find.text('Statistik'));
    await settle(tester);
    expect(find.text('Profit Factor'), findsOneWidget);
    await tester.tap(find.text('Pengaturan'));
    await settle(tester);
    expect(find.text('Export data (CSV)'), findsOneWidget);
    await tester.tap(find.text('Kalender'));
    await settle(tester);

    // Tap tanggal hari ini -> Detail Hari.
    final today = DateTime.now();
    await tester.tap(find.text('${today.day}').first);
    await settle(tester);
    expect(find.text('Belum ada trade di tanggal ini.'), findsOneWidget);

    // Tambah trade.
    await tester.tap(find.text('Tambah Trade'));
    await settle(tester);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Pair / instrumen *'), 'xauusd');
    await tester.enterText(find.widgetWithText(TextFormField, 'Lot size *'), '0.01');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Harga entry *'), '2650.5');
    final resultField = find.widgetWithText(TextFormField, 'Hasil P/L (USC) *');
    await tester.scrollUntilVisible(resultField, 200,
        scrollable: find
            .ancestor(
                of: find.text('Pair / instrumen *'),
                matching: find.byType(Scrollable))
            .last);
    await tester.enterText(resultField, '-12,5');
    await tester.tap(find.text('Simpan'));
    await settle(tester);

    // Kembali di Detail Hari, trade muncul.
    expect(find.text('XAUUSD'), findsOneWidget);
    expect(find.text('-12.5 USC'), findsWidgets);

    // Buka trade (mode lihat) lalu kembali ke kalender: sel jadi merah.
    await tester.tap(find.text('XAUUSD'));
    await settle(tester);
    expect(find.text('Detail Trade'), findsOneWidget);
    await tester.pageBack();
    await settle(tester);
    await tester.pageBack();
    await settle(tester);
    final cell = tester.widget<Container>(find
        .ancestor(of: find.text('-12.5'), matching: find.byType(Container))
        .first);
    expect((cell.decoration as BoxDecoration).color, AppColors.loss);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
  });
}
