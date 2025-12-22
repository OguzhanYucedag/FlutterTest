import 'package:flutter/material.dart';
import '../utils/sabitler.dart';
import 'dart:math';

class DuyguOyunu extends StatefulWidget {
  const DuyguOyunu({super.key});

  @override
  State<DuyguOyunu> createState() => _DuyguOyunuState();
}

class _DuyguOyunuState extends State<DuyguOyunu> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> duygular = [
    {'ad': 'Mutlu', 'emoji': '😊'},
    {'ad': 'Üzgün', 'emoji': '😢'},
    {'ad': 'Kızgın', 'emoji': '😠'},
    {'ad': 'Şaşkın', 'emoji': '😮'},
    {'ad': 'Korkmuş', 'emoji': '😨'},
    {'ad': 'Uykulu', 'emoji': '😴'},
    {'ad': 'sinirli', 'emoji': '😤'},
    {'ad': 'Sevimli', 'emoji': '🥰'},
  ];

  late int hedef;
  late List<int> secenekler;
  int skor = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    oyunuKur();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void oyunuKur() {
    setState(() {
      hedef = Random().nextInt(duygular.length);
      List<int> tumSecenekler = List.generate(duygular.length, (i) => i);
      tumSecenekler.shuffle();
      secenekler = tumSecenekler.take(4).toList();
      if (!secenekler.contains(hedef)) {
        secenekler[Random().nextInt(4)] = hedef;
      }
      secenekler.shuffle();
    });
  }

  void kontrolEt(int id) {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    if (id == hedef) {
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
      Future.delayed(const Duration(milliseconds: 900), oyunuKur);
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
        title: const Text("Duyguları Tanı", style: Sabitler.baslikStili),
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
                "Kim ${duygular[hedef]['ad']}?",
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
                    int id = secenekler[index];
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
                          child: InkWell(
                            onTap: () => kontrolEt(id),
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.pink, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink.withOpacity(0.2),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  duygular[id]['emoji']!,
                                  style: const TextStyle(fontSize: 80),
                                ),
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

