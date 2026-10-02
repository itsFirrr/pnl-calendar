import 'dart:io';

import 'package:flutter/material.dart';

import '../screenshot_storage.dart';

class ScreenshotPicker extends StatelessWidget {
  const ScreenshotPicker({
    super.key,
    required this.path,
    required this.enabled,
    required this.onChanged,
  });

  final String? path;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  Future<void> _pick(BuildContext context) async {
    try {
      final stored = await pickAndStoreScreenshot();
      if (stored != null) onChanged(stored);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal mengambil gambar: $e')));
    }
  }

  void _openFullscreen(BuildContext context, String path) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                maxScale: 5,
                child: Image.file(File(path), fit: BoxFit.contain),
              ),
            ),
            SafeArea(
              child: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = path;
    if (current == null) {
      if (!enabled) return const Text('Tidak ada screenshot');
      return OutlinedButton.icon(
        onPressed: () => _pick(context),
        icon: const Icon(Icons.add_photo_alternate_outlined),
        label: const Text('Pilih dari galeri'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _openFullscreen(context, current),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(current),
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, _, _) => const SizedBox(
                height: 80,
                child: Center(child: Text('File screenshot tidak ditemukan')),
              ),
            ),
          ),
        ),
        if (enabled)
          Row(
            children: [
              TextButton.icon(
                onPressed: () => _pick(context),
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Ganti'),
              ),
              TextButton.icon(
                onPressed: () => onChanged(null),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Hapus'),
              ),
            ],
          ),
      ],
    );
  }
}
