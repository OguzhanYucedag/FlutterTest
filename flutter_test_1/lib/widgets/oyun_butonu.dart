import 'package:flutter/material.dart';
import '../utils/sabitler.dart';

class OyunButonu extends StatelessWidget {
  final String baslik;
  final String ikon;
  final Color renk;
  final VoidCallback onTap;

  const OyunButonu({
    super.key,
    required this.baslik,
    required this.ikon,
    required this.renk,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: renk.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: renk.withOpacity(0.3), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ikon,
              style: const TextStyle(fontSize: 50),
            ),
            const SizedBox(height: 12),
            Text(
              baslik,
              style: Sabitler.kartMetniStili,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

