<p align="center">
  <img src="assets/icon/icon.png" width="120" alt="Kalender PNL logo">
</p>

<h1 align="center">Kalender PNL</h1>

<p align="center">Jurnal trading pribadi berbentuk kalender profit/loss. Offline, tanpa akun.</p>

## Fitur

- **Kalender P/L**: setiap tanggal berwarna hijau (net profit), merah (net loss), atau abu-abu (tidak ada trade). Warna dihitung dari net total semua trade di tanggal itu. Ringkasan bulanan menampilkan total P/L, jumlah trading day, dan win rate.
- **Jurnal per trade**: pair, arah, lot, harga entry/SL/TP/exit, hasil dalam USC, status, alasan entry & exit, kondisi psikologis, dan screenshot chart dari galeri.
- **Statistik**: filter Minggu ini, Bulan ini, Semua, atau rentang custom.
  - Rangkuman otomatis per periode beserta kumpulan catatan jurnal.
  - Win rate, total P/L, profit factor, streak win/loss, dan average RR.
  - Equity curve.
  - Breakdown per pair, per hari dalam seminggu, dan win rate per kondisi psikologis (mood).
- **Export CSV**: backup semua trade lalu bagikan atau simpan lewat share sheet.

Semua data disimpan lokal di perangkat (SQLite). Tidak ada login, tidak ada cloud.

## Tech stack

| Bagian | Library |
| --- | --- |
| Framework | Flutter (target utama Android) |
| State management | `flutter_riverpod` |
| Routing | `go_router` (`StatefulShellRoute`, 3 tab) |
| Database | `drift` (SQLite) |
| Kalender | `table_calendar` |
| Chart | `fl_chart` |
| Lainnya | `image_picker`, `path_provider`, `csv`, `share_plus`, `intl` |

Alur arsitektur: Widget → Riverpod provider → `TradeRepository` → Drift database.

```
lib/
├── core/          tema, warna, formatter, utilitas tanggal
├── data/          tabel Drift, database, repository
└── features/      calendar, day_detail, trade_detail, statistics, settings
```

## Menjalankan

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generate database.g.dart
flutter run
```

Perintah lain:

```bash
flutter test                  # unit & widget test
flutter build apk --release   # build APK
```

Ikon dan splash screen dibuat dari `assets/icon/`. Kalau logo diubah, generate ulang dengan:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Lisensi

[MIT](LICENSE) © 2026 [itsFirrr](https://github.com/itsFirrr)
