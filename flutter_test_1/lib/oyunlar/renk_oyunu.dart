import 'package:flutter/material.dart';
import '../utils/sabitler.dart';
import 'dart:math';

class RenkOyunu extends StatefulWidget {
  const RenkOyunu({super.key});

  @override
  State<RenkOyunu> createState() => _RenkOyunuState();
}

class _RenkOyunuState extends State<RenkOyunu> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> renkler = [
    {'ad': 'Kırmızı', 'renk': Colors.red},
    {'ad': 'Mavi', 'renk': Colors.blue},
    {'ad': 'Yeşil', 'renk': Colors.green},
    {'ad': 'Sarı', 'renk': Colors.yellow},
    {'ad': 'Turuncu', 'renk': Colors.orange},
    {'ad': 'Mor', 'renk': Colors.purple},
    {'ad': 'Pembe', 'renk': Colors.pink},
    {'ad': 'Kahverengi', 'renk': Colors.brown},
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
      hedefIndeks = Random().nextInt(renkler.length);
      List<int> tumSecenekler = List.generate(renkler.length, (index) => index);
      tumSecenekler.shuffle();
      secenekler = tumSecenekler.take(4).toList();
      if (!secenekler.contains(hedefIndeks)) {
        secenekler[Random().nextInt(4)] = hedefIndeks;
      }
      secenekler.shuffle();
    });
  }

  void kontrolEt(int indeks) {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    
    if (indeks == hedefIndeks) {
      setState(() {
        skor++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Harika! Doğru! Skor: $skor"),
          backgroundColor: Sabitler.dogruRenk,
          duration: const Duration(milliseconds: 800),
        ),
      );
      Future.delayed(const Duration(milliseconds: 900), oyunuBaslat);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tekrar Dene"),
          backgroundColor: Sabitler.yanlisRenk,
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Sabitler.arkaPlan,
      appBar: AppBar(
        title: const Text("Renkleri Bul", style: Sabitler.baslikStili),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "Skor: $skor",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                "${renkler[hedefIndeks]['ad']} nerede?",
                style: Sabitler.soruStili,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    int itemIndeks = secenekler[index];
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index > 0 ? 10 : 0,
                          right: index < 3 ? 10 : 0,
                        ),
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 - (_animationController.value * 0.1),
                              child: child,
                            );
                          },
                          child: GestureDetector(
                            onTap: () => kontrolEt(itemIndeks),
                            child: Container(
                              decoration: BoxDecoration(
                                color: renkler[itemIndeks]['renk'],
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 6,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: renkler[itemIndeks]['renk'].withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
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
          ],
        ),
      ),
    );
  }
}

