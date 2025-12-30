import 'package:flutter/material.dart';
import '../utils/sabitler.dart';

class KartEslestirmeOyunu extends StatefulWidget {
  const KartEslestirmeOyunu({super.key});

  @override
  State<KartEslestirmeOyunu> createState() => _KartEslestirmeOyunuState();
}

class _KartEslestirmeOyunuState extends State<KartEslestirmeOyunu> {
  late List<Map<String, dynamic>> kartlar;
  late List<bool> acik;
  List<int> eslesen = [];
  int skor = 0;
  int? secili1;
  int? secili2;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    oyunuBaslat();
  }

  void oyunuBaslat() {
    final base = [
      {'emoji': '🦁', 'id': 0},
      {'emoji': '🍎', 'id': 1},
      {'emoji': '🚗', 'id': 2},
      {'emoji': '⭐', 'id': 3},
      {'emoji': '❤️', 'id': 4},
      {'emoji': '🎨', 'id': 5},
      {'emoji': '🐶', 'id': 6},
      {'emoji': '🚀', 'id': 7},
    ];
    kartlar = [];
    for (var k in base) {
      kartlar.add({...k});
      kartlar.add({...k});
    }
    kartlar.shuffle();
    acik = List.filled(kartlar.length, false);
    eslesen = [];
    skor = 0;
    secili1 = null;
    secili2 = null;
    setState(() {});
  }

  void tikla(int i) {
    if (_checking) return;
    if (acik[i] || eslesen.contains(i)) return;

    // Open the tapped card
    setState(() {
      acik[i] = true;
    });

    if (secili1 == null) {
      secili1 = i;
      return;
    }

    if (secili2 == null && secili1 != i) {
      secili2 = i;
      _checking = true; // block further taps until check finishes

      Future.delayed(const Duration(milliseconds: 700), () {
        final match = kartlar[secili1!]['id'] == kartlar[secili2!]['id'];
        if (match) {
          setState(() {
            eslesen.add(secili1!);
            eslesen.add(secili2!);
            skor++;
          });

          if (eslesen.length == kartlar.length) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tebrikler! Skor: $skor'), backgroundColor: Sabitler.dogruRenk),
            );
            Future.delayed(const Duration(milliseconds: 1200), oyunuBaslat);
          }
        } else {
          // close both cards with setState so UI updates
          setState(() {
            acik[secili1!] = false;
            acik[secili2!] = false;
          });
        }

        secili1 = null;
        secili2 = null;
        _checking = false;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final cardSize = (screenW - 16 - (3 * 8)) / 4; // responsive square size

    return Scaffold(
      backgroundColor: Sabitler.arkaPlan,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Kart Eşleştirme', style: Sabitler.baslikStili),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [Padding(padding: const EdgeInsets.all(12.0), child: Center(child: Text('Skor: $skor')))],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: GridView.builder(
            itemCount: kartlar.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.9),
            itemBuilder: (context, index) {
              final visible = acik[index] || eslesen.contains(index);
              return GestureDetector(
                onTap: () => tikla(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: visible
                        ? const LinearGradient(colors: [Colors.white, Colors.white])
                        : LinearGradient(colors: [Colors.yellow.shade600, Colors.yellow.shade300]),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: visible ? 20 : 12,
                        offset: Offset(0, visible ? 12 : 6),
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 6),
                  ),
                  child: Center(
                    child: Container(
                      width: cardSize * 0.68,
                      height: cardSize * 0.68,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: visible
                            ? [BoxShadow(color: Sabitler.anaRenk.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 8))]
                            : [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Center(
                        child: Builder(builder: (ctx) {
                          if (visible) {
                            return Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 10,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  kartlar[index]['emoji'],
                                  style: TextStyle(
                                    fontSize: cardSize * 0.36,
                                    shadows: [const Shadow(color: Colors.black12, blurRadius: 6)],
                                  ),
                                ),
                              ),
                            );
                          }

                          // Hidden state: improved image presentation with clipping, high filter quality and nicer shadow
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: cardSize * 0.52,
                              height: cardSize * 0.52,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.white, Colors.grey.shade100],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    'assets/images/card_back.png',
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                    errorBuilder: (context, error, stackTrace) => const Center(child: Text('🃏', style: TextStyle(fontSize: 28))),
                                  ),
                                  // soft overlay to make icons pop
                                  Container(
                                    color: Colors.black.withOpacity(0.02),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
