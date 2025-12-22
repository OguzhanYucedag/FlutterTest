import 'package:flutter/material.dart';
import '../utils/sabitler.dart';
import 'dart:math';

class SayiOyunu extends StatefulWidget {
  const SayiOyunu({super.key});

  @override
  State<SayiOyunu> createState() => _SayiOyunuState();
}

class _SayiOyunuState extends State<SayiOyunu> with SingleTickerProviderStateMixin {
  late int hedefSayi;
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
      hedefSayi = Random().nextInt(9) + 1;
      secenekler = [hedefSayi];
      while (secenekler.length < 4) {
        int r = Random().nextInt(9) + 1;
        if (!secenekler.contains(r)) secenekler.add(r);
      }
      secenekler.shuffle();
    });
  }

  void kontrolEt(int s) {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    if (s == hedefSayi) {
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
        title: const Text("Sayıları Öğren", style: Sabitler.baslikStili),
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
                "Sayı $hedefSayi nerede?",
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
                    int s = secenekler[index];
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
                            onTap: () => kontrolEt(s),
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Sabitler.anaRenk.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Sabitler.anaRenk, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Sabitler.anaRenk.withOpacity(0.2),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "$s",
                                  style: TextStyle(
                                    fontSize: 70,
                                    fontWeight: FontWeight.bold,
                                    color: Sabitler.anaRenk,
                                  ),
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

