import 'package:flutter/material.dart';

/// Tiga warna solid kalender - tidak ada gradasi berdasarkan besar P/L.
class AppColors {
  static const profit = Color(0xFF2E7D32);
  static const loss = Color(0xFFC62828);
  static const neutral = Color(0xFFE0E0E0);

  static Color forResult(double? net) {
    if (net == null || net == 0) return neutral;
    return net > 0 ? profit : loss;
  }

  /// Warna teks untuk angka P/L di atas latar biasa.
  static Color textForResult(double net, ColorScheme scheme) {
    if (net == 0) return scheme.onSurfaceVariant;
    return net > 0 ? profit : loss;
  }
}
