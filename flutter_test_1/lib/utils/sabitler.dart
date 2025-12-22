import 'package:flutter/material.dart';

class Sabitler {
  // Renk Paleti (Göz yormayan ama belirgin renkler)
  static const Color anaRenk = Color(0xFF6C63FF);
  static const Color arkaPlan = Color(0xFFF8F9FA);
  static const Color dogruRenk = Colors.green;
  static const Color yanlisRenk = Colors.red;

  // Metin Stilleri
  static const TextStyle baslikStili = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color(0xFF2D3436),
  );

  static const TextStyle kartMetniStili = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2D3436),
  );

  static const TextStyle soruStili = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: anaRenk,
  );
}

