import 'package:flutter/material.dart';

class OgretmenGirisPage extends StatelessWidget {
  const OgretmenGirisPage({
    super.key,
    required this.ad,
    required this.email,
    required this.tip,
  });

  final String ad;
  final String email;
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hoş geldin, $ad'),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ad: $ad', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Email: $email', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Tip: $tip', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            const Text(
              'Buraya öğretmen ekranı içeriği eklenecek.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
