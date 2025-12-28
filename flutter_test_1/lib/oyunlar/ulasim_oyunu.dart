import 'package:flutter/material.dart';
import '../utils/sabitler.dart';
import 'dart:math';

class UlasimOyunu extends StatefulWidget {
  const UlasimOyunu({super.key});

  @override
  State<UlasimOyunu> createState() => _UlasimOyunuState();
}

class _UlasimOyunuState extends State<UlasimOyunu> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> araclar = [
    {'ad': 'Araba', 'emoji': '🚗'},
    {'ad': 'Otobüs', 'emoji': '🚌'},
    {'ad': 'Tren', 'emoji': '🚂'},
    {'ad': 'Uçak', 'emoji': '✈️'},
    {'ad': 'Gemi', 'emoji': '🚢'},
    {'ad': 'Bisiklet', 'emoji': '🚲'},
    {'ad': 'Motorsiklet', 'emoji': '🏍️'},
    {'ad': 'Helikopter', 'emoji': '🚁'},
  ];

  late int hedefIndeks;
  List<int> secenekler = [];
  int skor = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    oyunuBaslat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void oyunuBaslat() {
    setState(() {
      hedefIndeks = Random().nextInt(araclar.length);
      List<int> tum = List.generate(araclar.length, (i) => i);
      tum.shuffle();
      secenekler = tum.take(4).toList();
      if (!secenekler.contains(hedefIndeks)) {
        secenekler[Random().nextInt(4)] = hedefIndeks;
      }
      secenekler.shuffle();
    });
  }

  void kontrolEt(int indeks) {
    _animationController.forward().then((_) => _animationController.reverse());
    if (indeks == hedefIndeks) {
      setState(() => skor++);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Doğru! Skor: $skor'), backgroundColor: Sabitler.dogruRenk, duration: const Duration(milliseconds: 800)),
      );
      Future.delayed(const Duration(milliseconds: 900), oyunuBaslat);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tekrar Dene'), backgroundColor: Sabitler.yanlisRenk, duration: Duration(milliseconds: 500)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final panelH = min(520.0, screenH * 0.58);

    return Scaffold(
      backgroundColor: Sabitler.arkaPlan,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Ulaşımı Bul', style: Sabitler.baslikStili),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(child: Text('Skor: $skor', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Soru balonu
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Sabitler.anaRenk, Sabitler.anaRenk.withOpacity(0.85)]),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Sabitler.anaRenk.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 6))],
                ),
                child: Text('${araclar[hedefIndeks]['ad']} nerede?', style: Sabitler.soruStili.copyWith(color: Colors.white), textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 18),
            // Kartlar
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(4, (i) {
                    final item = secenekler[i];
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: i > 0 ? 10 : 0, right: i < 3 ? 10 : 0),
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            final scale = 1.0 - (_animationController.value * 0.04);
                            return Transform.scale(scale: scale, child: child);
                          },
                          child: GestureDetector(
                            onTap: () => kontrolEt(item),
                            child: Container(
                              height: panelH,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                gradient: LinearGradient(colors: [Colors.white, Colors.white.withOpacity(0.95)]),
                                border: Border.all(color: Sabitler.anaRenk.withOpacity(0.25), width: 6),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 8))],
                              ),
                              child: Stack(
                                children: [
                                  // soft inner glow behind emoji
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(colors: [Sabitler.anaRenk.withOpacity(0.12), Colors.transparent]),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // emoji
                                  Positioned.fill(
                                    child: Align(
                                      alignment: const Alignment(0, 0.05),
                                      child: Text(araclar[item]['emoji']!, style: const TextStyle(fontSize: 56)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
