import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/labels.dart';
import '../../core/utils/formatters.dart';
import '../../data/repository/trade_repository.dart';
import 'trade_detail_provider.dart';
import 'widgets/emotion_selector.dart';
import 'widgets/screenshot_picker.dart';

/// [tradeId] null = mode tambah baru (tanggal default [initialDate]/hari ini).
class TradeDetailScreen extends ConsumerWidget {
  const TradeDetailScreen({super.key, this.tradeId, this.initialDate});

  final int? tradeId;
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = tradeId;
    if (id == null) {
      return _TradeForm(
          args: (existing: null, initialDate: initialDate ?? DateTime.now()));
    }
    return ref.watch(tradeByIdProvider(id)).when(
          loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(
              appBar: AppBar(),
              body: Center(child: Text('Gagal memuat trade: $e'))),
          data: (trade) => trade == null
              ? Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Trade tidak ditemukan')))
              : _TradeForm(args: (existing: trade, initialDate: trade.date)),
        );
  }
}

class _TradeForm extends ConsumerWidget {
  const _TradeForm({required this.args});

  final TradeFormArgs args;

  bool get _isNew => args.existing == null;

  Future<void> _save(BuildContext context, TradeFormNotifier notifier) async {
    final error = notifier.validate();
    final messenger = ScaffoldMessenger.of(context);
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    try {
      await notifier.save();
      messenger.showSnackBar(SnackBar(
          content: Text(_isNew ? 'Trade tersimpan' : 'Trade diperbarui')));
      if (_isNew && context.mounted) context.pop();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    }
  }

  Future<void> _delete(BuildContext context, TradeFormNotifier notifier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus trade?'),
        content: const Text(
            'Trade ini beserta screenshot-nya akan dihapus permanen.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await notifier.delete();
      messenger.showSnackBar(const SnackBar(content: Text('Trade dihapus')));
      if (context.mounted) context.pop();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
    }
  }

  Future<DateTime?> _pickDateTime(
      BuildContext context, DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100, 12, 31),
    );
    if (date == null || !context.mounted) return null;
    final time = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(initial));
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(tradeFormProvider(args));
    final notifier = ref.read(tradeFormProvider(args).notifier);
    final editing = s.isEditing;

    Widget text(
      String label,
      String value,
      ValueChanged<String> onChanged, {
      bool number = false,
      bool signed = false,
      int maxLines = 1,
      String? hint,
    }) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            initialValue: value,
            readOnly: !editing,
            onChanged: onChanged,
            maxLines: maxLines,
            minLines: maxLines > 1 ? 3 : 1,
            textCapitalization: number
                ? TextCapitalization.none
                : TextCapitalization.sentences,
            keyboardType: number
                ? TextInputType.numberWithOptions(decimal: true, signed: signed)
                : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
            decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                border: const OutlineInputBorder()),
          ),
        );

    Widget section(String title) => Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleSmall),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew
            ? 'Tambah Trade'
            : editing
                ? 'Edit Trade'
                : 'Detail Trade'),
        actions: [
          if (!_isNew && !editing)
            IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_outlined),
                onPressed: notifier.startEditing),
          if (!_isNew && editing)
            IconButton(
                tooltip: 'Batal edit',
                icon: const Icon(Icons.close),
                onPressed: notifier.cancelEditing),
          if (!_isNew)
            IconButton(
                tooltip: 'Hapus',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _delete(context, notifier)),
        ],
      ),
      bottomNavigationBar: editing
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: FilledButton(
                  onPressed: s.isSaving ? null : () => _save(context, notifier),
                  child: Text(_isNew ? 'Simpan' : 'Update'),
                ),
              ),
            )
          : null,
      body: ListView(
        key: ValueKey(s.formVersion),
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Pair
          text('Pair / instrumen *', s.pair,
              (v) => notifier.edit((s) => s.copyWith(pair: v)),
              hint: 'contoh: XAUUSD'),
          // 2. Arah
          SegmentedButton<TradeDirection>(
            segments: [
              for (final d in TradeDirection.values)
                ButtonSegment(value: d, label: Text(d.label)),
            ],
            selected: {s.direction},
            onSelectionChanged: editing
                ? (v) => notifier.edit((s) => s.copyWith(direction: v.first))
                : null,
          ),
          // 3. Waktu entry & exit (tanggal trade = tanggal waktu entry)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.login),
            title: const Text('Waktu entry'),
            subtitle: Text(formatDateTime(s.entryTime)),
            onTap: editing
                ? () async {
                    final v = await _pickDateTime(context, s.entryTime);
                    if (v != null) {
                      notifier.edit((s) => s.copyWith(entryTime: v));
                    }
                  }
                : null,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout),
            title: const Text('Waktu exit'),
            subtitle: Text(
                s.exitTime == null ? '-' : formatDateTime(s.exitTime!)),
            trailing: editing && s.exitTime != null
                ? IconButton(
                    tooltip: 'Kosongkan',
                    icon: const Icon(Icons.clear),
                    onPressed: () =>
                        notifier.edit((s) => s.copyWith(exitTime: () => null)),
                  )
                : null,
            onTap: editing
                ? () async {
                    final v = await _pickDateTime(
                        context, s.exitTime ?? s.entryTime);
                    if (v != null) {
                      notifier.edit((s) => s.copyWith(exitTime: () => v));
                    }
                  }
                : null,
          ),
          const SizedBox(height: 8),
          // 4. Lot
          text('Lot size *', s.lotSize,
              (v) => notifier.edit((s) => s.copyWith(lotSize: v)),
              number: true),
          // 5. Harga
          Row(children: [
            Expanded(
                child: text('Harga entry *', s.entryPrice,
                    (v) => notifier.edit((s) => s.copyWith(entryPrice: v)),
                    number: true)),
            const SizedBox(width: 12),
            Expanded(
                child: text('Harga exit', s.exitPrice,
                    (v) => notifier.edit((s) => s.copyWith(exitPrice: v)),
                    number: true)),
          ]),
          Row(children: [
            Expanded(
                child: text('Stop loss', s.slPrice,
                    (v) => notifier.edit((s) => s.copyWith(slPrice: v)),
                    number: true)),
            const SizedBox(width: 12),
            Expanded(
                child: text('Take profit', s.tpPrice,
                    (v) => notifier.edit((s) => s.copyWith(tpPrice: v)),
                    number: true)),
          ]),
          // 6. Hasil
          text('Hasil P/L (USC) *', s.resultUsc,
              (v) => notifier.edit((s) => s.copyWith(resultUsc: v)),
              number: true, signed: true, hint: 'negatif untuk loss, misal -8.5'),
          // 7. Status
          DropdownButtonFormField<TradeStatus>(
            initialValue: s.status,
            decoration: const InputDecoration(
                labelText: 'Status', border: OutlineInputBorder()),
            items: [
              for (final st in TradeStatus.values)
                DropdownMenuItem(value: st, child: Text(st.label)),
            ],
            onChanged: editing
                ? (v) => notifier.edit((s) => s.copyWith(status: v))
                : null,
          ),
          // 8. Screenshot
          section('Screenshot chart'),
          ScreenshotPicker(
            path: s.screenshotPath,
            enabled: editing,
            onChanged: (v) =>
                notifier.edit((s) => s.copyWith(screenshotPath: () => v)),
          ),
          const SizedBox(height: 12),
          // 9-10. Jurnal
          section('Jurnal'),
          text('Alasan entry', s.entryReason,
              (v) => notifier.edit((s) => s.copyWith(entryReason: v)),
              maxLines: 5),
          text('Alasan exit', s.exitReason,
              (v) => notifier.edit((s) => s.copyWith(exitReason: v)),
              maxLines: 5),
          // 11. Psikologis
          section('Kondisi psikologis'),
          EmotionSelector(
            value: s.emotion,
            enabled: editing,
            onChanged: (v) => notifier.edit((s) => s.copyWith(emotion: () => v)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
