import 'package:flutter/material.dart';
import 'main.dart';

class AnasayfaPageKurum extends StatelessWidget {
  const AnasayfaPageKurum({super.key, this.ad, this.email, this.tip});

  final String? ad;
  final String? email;
  final String? tip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Ana Sayfa',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hoş Geldiniz! $ad',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              if (email != null && email!.isNotEmpty) ...[
                Text(
                  'Email: $email',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
              ],
              if (ad != null && ad!.isNotEmpty) ...[
                Text(
                  'Ad: $ad',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
              ],
              if (tip != null && tip!.isNotEmpty) ...[
                Text(
                  'Tip: $tip',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
//ahmetahmet