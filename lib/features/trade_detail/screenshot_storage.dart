import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Ambil gambar dari galeri lalu salin ke folder aplikasi. Yang disimpan ke
/// database hanya path hasil salinan ini (bukan BLOB).
Future<String?> pickAndStoreScreenshot() async {
  final picked = await ImagePicker()
      .pickImage(source: ImageSource.gallery, imageQuality: 85);
  if (picked == null) return null;

  final docs = await getApplicationDocumentsDirectory();
  final dir = Directory(p.join(docs.path, 'screenshots'));
  await dir.create(recursive: true);

  final ext = p.extension(picked.path).isEmpty ? '.jpg' : p.extension(picked.path);
  final dest =
      p.join(dir.path, 'ss_${DateTime.now().millisecondsSinceEpoch}$ext');
  await picked.saveTo(dest);
  return dest;
}

Future<void> deleteScreenshotFile(String? path) async {
  if (path == null) return;
  final file = File(path);
  if (await file.exists()) await file.delete();
}
