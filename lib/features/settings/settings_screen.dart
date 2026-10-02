import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import 'export_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _exporting = false;

  Future<void> _export() async {
    setState(() => _exporting = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(exportServiceProvider).exportAndShare();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export gagal: $e')));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.file_download_outlined),
            title: const Text('Export data (CSV)'),
            subtitle: const Text(
                'Backup semua trade, lalu simpan atau bagikan file-nya'),
            trailing: _exporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : null,
            onTap: _exporting ? null : _export,
          ),
          const ListTile(
            enabled: false,
            leading: Icon(Icons.file_upload_outlined),
            title: Text('Import histori broker'),
            subtitle: Text('Segera hadir'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Versi aplikasi'),
            subtitle: Text(appVersion),
          ),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text('Source code'),
            subtitle: Text(appGithubUrl),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '© $appCopyrightYear $appAuthor · MIT License',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
