import 'package:flutter/material.dart';
import '../widgets/oyun_butonu.dart';
import '../utils/sabitler.dart';
import '../oyunlar/ulasim_oyunu.dart';
import '../oyunlar/kart_eslestirme_oyunu.dart';
import 'dart:math';

class OyunlarimVeli extends StatefulWidget {
  const OyunlarimVeli({super.key});

  @override
  State<OyunlarimVeli> createState() => _OyunlarimVeliState();
}

class _OyunlarimVeliState extends State<OyunlarimVeli> with SingleTickerProviderStateMixin {
  String? secilenOyun;
  late AnimationController _animationController;

  // Renk Oyunu
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
  late int renkHedefIndeks;
  List<int> renkSecenekler = [];
  int renkSkor = 0;

  // Hayvan Oyunu
  final List<Map<String, String>> hayvanlar = [
    {'ad': 'Aslan', 'emoji': '🦁'},
    {'ad': 'Fil', 'emoji': '🐘'},
    {'ad': 'Köpek', 'emoji': '🐶'},
    {'ad': 'Kedi', 'emoji': '🐱'},
    {'ad': 'Ayı', 'emoji': '🐻'},
    {'ad': 'Zürafa', 'emoji': '🦒'},
    {'ad': 'Tavşan', 'emoji': '🐰'},
    {'ad': 'Kaplan', 'emoji': '🐯'},
  ];
  late int hayvanHedef;
  late List<int> hayvanSecenekler;
  int hayvanSkor = 0;

  // Meyve Oyunu
  final List<Map<String, String>> meyveler = [
    {'ad': 'Elma', 'emoji': '🍎'},
    {'ad': 'Muz', 'emoji': '🍌'},
    {'ad': 'Çilek', 'emoji': '🍓'},
    {'ad': 'Üzüm', 'emoji': '🍇'},
    {'ad': 'Portakal', 'emoji': '🍊'},
    {'ad': 'Karpuz', 'emoji': '🍉'},
    {'ad': 'Ananas', 'emoji': '🍍'},
    {'ad': 'Kiraz', 'emoji': '🍒'},
  ];
  late int meyveHedef;
  late List<int> meyveSecenekler;
  int meyveSkor = 0;

  // Sayı Oyunu
  late int sayiHedef;
  late List<int> sayiSecenekler;
  int sayiSkor = 0;

  // Şekil Oyunu
  final List<Map<String, String>> sekiller = [
    {'ad': 'Kare', 'emoji': '⬜'},
    {'ad': 'Daire', 'emoji': '⚪'},
    {'ad': 'Üçgen', 'emoji': '🔺'},
    {'ad': 'Yıldız', 'emoji': '⭐'},
    {'ad': 'Kalp', 'emoji': '❤️'},
    {'ad': 'Dikdörtgen', 'emoji': '▭'},
    {'ad': 'Altıgen', 'emoji': '⬡'},
    {'ad': 'Diamond', 'emoji': '💎'},
  ];
  late int sekilHedef;
  late List<int> sekilSecenekler;
  int sekilSkor = 0;

  // Duygu Oyunu
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
  late int duyguHedef;
  late List<int> duyguSecenekler;
  int duyguSkor = 0;

  // Organ Oyunu
  final List<Map<String, String>> organlar = [
    {'ad': 'Kalp', 'emoji': '❤️'},
    {'ad': 'Göz', 'emoji': '👁️'},
    {'ad': 'Kulak', 'emoji': '👂'},
    {'ad': 'Burun', 'emoji': '👃'},
    {'ad': 'El', 'emoji': '✋'},
    {'ad': 'Ayak', 'emoji': '🦶'},
    {'ad': 'Diş', 'emoji': '🦷'},
    {'ad': 'Beyin', 'emoji': '🧠'},
  ];
  late int organHedef;
  late List<int> organSecenekler;
  int organSkor = 0;

  // Ulaşım Araçları Oyunu
  final List<Map<String, String>> ulasimAraclari = [
    {'ad': 'Araba', 'emoji': '🚗'},
    {'ad': 'Otobüs', 'emoji': '🚌'},
    {'ad': 'Tren', 'emoji': '🚂'},
    {'ad': 'Uçak', 'emoji': '✈️'},
    {'ad': 'Gemi', 'emoji': '🚢'},
    {'ad': 'Bisiklet', 'emoji': '🚲'},
    {'ad': 'Motorsiklet', 'emoji': '🏍️'},
    {'ad': 'Helikopter', 'emoji': '🚁'},
  ];
  late int ulasimHedef;
  late List<int> ulasimSecenekler;
  int ulasimSkor = 0;

  // Kart Eşleştirme Oyunu
  List<Map<String, dynamic>> kartEslestirmeKartlar = [];
  List<bool> kartEslestirmeAcik = [];
  List<int> kartEslestirmeEslesen = [];
  int? kartEslestirmeSecili1;
  int? kartEslestirmeSecili2;
  int kartEslestirmeSkor = 0;
  int kartEslestirmeEslesmeSayisi = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void oyunuBaslat(String oyunTipi) {
    setState(() {
      secilenOyun = oyunTipi;
    });

    switch (oyunTipi) {
      case 'renk':
        renkHedefIndeks = Random().nextInt(renkler.length);
        List<int> tumSecenekler = List.generate(renkler.length, (index) => index);
        tumSecenekler.shuffle();
        renkSecenekler = tumSecenekler.take(4).toList();
        if (!renkSecenekler.contains(renkHedefIndeks)) {
          renkSecenekler[Random().nextInt(4)] = renkHedefIndeks;
        }
        renkSecenekler.shuffle();
        break;
      case 'hayvan':
        hayvanHedef = Random().nextInt(hayvanlar.length);
        List<int> tumSecenekler = List.generate(hayvanlar.length, (i) => i);
        tumSecenekler.shuffle();
        hayvanSecenekler = tumSecenekler.take(4).toList();
        if (!hayvanSecenekler.contains(hayvanHedef)) {
          hayvanSecenekler[Random().nextInt(4)] = hayvanHedef;
        }
        hayvanSecenekler.shuffle();
        break;
      case 'meyve':
        meyveHedef = Random().nextInt(meyveler.length);
        List<int> tumSecenekler = List.generate(meyveler.length, (i) => i);
        tumSecenekler.shuffle();
        meyveSecenekler = tumSecenekler.take(4).toList();
        if (!meyveSecenekler.contains(meyveHedef)) {
          meyveSecenekler[Random().nextInt(4)] = meyveHedef;
        }
        meyveSecenekler.shuffle();
        break;
      case 'sayi':
        sayiHedef = Random().nextInt(9) + 1;
        sayiSecenekler = [sayiHedef];
        while (sayiSecenekler.length < 4) {
          int r = Random().nextInt(9) + 1;
          if (!sayiSecenekler.contains(r)) sayiSecenekler.add(r);
        }
        sayiSecenekler.shuffle();
        break;
      case 'sekil':
        sekilHedef = Random().nextInt(sekiller.length);
        List<int> tumSecenekler = List.generate(sekiller.length, (i) => i);
        tumSecenekler.shuffle();
        sekilSecenekler = tumSecenekler.take(4).toList();
        if (!sekilSecenekler.contains(sekilHedef)) {
          sekilSecenekler[Random().nextInt(4)] = sekilHedef;
        }
        sekilSecenekler.shuffle();
        break;
      case 'duygu':
        duyguHedef = Random().nextInt(duygular.length);
        List<int> tumSecenekler = List.generate(duygular.length, (i) => i);
        tumSecenekler.shuffle();
        duyguSecenekler = tumSecenekler.take(4).toList();
        if (!duyguSecenekler.contains(duyguHedef)) {
          duyguSecenekler[Random().nextInt(4)] = duyguHedef;
        }
        duyguSecenekler.shuffle();
        break;
      case 'organ':
        organHedef = Random().nextInt(organlar.length);
        List<int> tumSecenekler = List.generate(organlar.length, (i) => i);
        tumSecenekler.shuffle();
        organSecenekler = tumSecenekler.take(4).toList();
        if (!organSecenekler.contains(organHedef)) {
          organSecenekler[Random().nextInt(4)] = organHedef;
        }
        organSecenekler.shuffle();
        break;
      case 'ulasim':
        ulasimHedef = Random().nextInt(ulasimAraclari.length);
        List<int> tumSecenekler = List.generate(ulasimAraclari.length, (i) => i);
        tumSecenekler.shuffle();
        ulasimSecenekler = tumSecenekler.take(4).toList();
        if (!ulasimSecenekler.contains(ulasimHedef)) {
          ulasimSecenekler[Random().nextInt(4)] = ulasimHedef;
        }
        ulasimSecenekler.shuffle();
        break;
      case 'kart':
        // 8 çift kart (16 kart toplam) - 4x4 grid
        final kartlar = [
          {'emoji': '🦁', 'id': 0},
          {'emoji': '🍎', 'id': 1},
          {'emoji': '🚗', 'id': 2},
          {'emoji': '⭐', 'id': 3},
          {'emoji': '❤️', 'id': 4},
          {'emoji': '🎨', 'id': 5},
          {'emoji': '🐶', 'id': 6},
          {'emoji': '🚀', 'id': 7},
        ];
        kartEslestirmeKartlar = [];
        for (var kart in kartlar) {
          kartEslestirmeKartlar.add({...kart});
          kartEslestirmeKartlar.add({...kart});
        }
        kartEslestirmeKartlar.shuffle();
        kartEslestirmeAcik = List.filled(16, false);
        kartEslestirmeEslesen = [];
        kartEslestirmeSecili1 = null;
        kartEslestirmeSecili2 = null;
        kartEslestirmeEslesmeSayisi = 0;
        break;
    }
  }

  void kontrolEt(String oyunTipi, int indeks) {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    bool dogru = false;
    int yeniSkor = 0;

    switch (oyunTipi) {
      case 'renk':
        if (indeks == renkHedefIndeks) {
          renkSkor++;
          dogru = true;
          yeniSkor = renkSkor;
        }
        break;
      case 'hayvan':
        if (indeks == hayvanHedef) {
          hayvanSkor++;
          dogru = true;
          yeniSkor = hayvanSkor;
        }
        break;
      case 'meyve':
        if (indeks == meyveHedef) {
          meyveSkor++;
          dogru = true;
          yeniSkor = meyveSkor;
        }
        break;
      case 'sayi':
        if (indeks == sayiHedef) {
          sayiSkor++;
          dogru = true;
          yeniSkor = sayiSkor;
        }
        break;
      case 'sekil':
        if (indeks == sekilHedef) {
          sekilSkor++;
          dogru = true;
          yeniSkor = sekilSkor;
        }
        break;
      case 'duygu':
        if (indeks == duyguHedef) {
          duyguSkor++;
          dogru = true;
          yeniSkor = duyguSkor;
        }
        break;
      case 'organ':
        if (indeks == organHedef) {
          organSkor++;
          dogru = true;
          yeniSkor = organSkor;
        }
        break;
      case 'ulasim':
        if (indeks == ulasimHedef) {
          ulasimSkor++;
          dogru = true;
          yeniSkor = ulasimSkor;
        }
        break;
      case 'kart':
        // Kart eşleştirme mantığı
        if (kartEslestirmeEslesen.contains(indeks)) {
          return; // Zaten eşleşmiş kart
        }
        if (kartEslestirmeSecili1 == null) {
          kartEslestirmeSecili1 = indeks;
          kartEslestirmeAcik[indeks] = true;
          setState(() {});
          return;
        } else if (kartEslestirmeSecili2 == null && kartEslestirmeSecili1 != indeks) {
          kartEslestirmeSecili2 = indeks;
          kartEslestirmeAcik[indeks] = true;
          setState(() {});
          
          // Eşleşme kontrolü
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (kartEslestirmeKartlar[kartEslestirmeSecili1!]['id'] == 
                kartEslestirmeKartlar[kartEslestirmeSecili2!]['id']) {
              kartEslestirmeEslesen.add(kartEslestirmeSecili1!);
              kartEslestirmeEslesen.add(kartEslestirmeSecili2!);
              kartEslestirmeSkor++;
              kartEslestirmeEslesmeSayisi++;
              
              if (kartEslestirmeEslesmeSayisi == 8) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Tebrikler! Tüm kartları eşleştirdiniz! Skor: ${kartEslestirmeSkor}"),
                    backgroundColor: Sabitler.dogruRenk,
                    duration: const Duration(seconds: 2),
                  ),
                );
                Future.delayed(const Duration(milliseconds: 2500), () {
                  oyunuBaslat('kart');
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Harika! Eşleşme buldunuz! Skor: ${kartEslestirmeSkor}"),
                    backgroundColor: Sabitler.dogruRenk,
                    duration: const Duration(milliseconds: 800),
                  ),
                );
              }
            } else {
              kartEslestirmeAcik[kartEslestirmeSecili1!] = false;
              kartEslestirmeAcik[kartEslestirmeSecili2!] = false;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Eşleşme bulunamadı, tekrar deneyin"),
                  backgroundColor: Sabitler.yanlisRenk,
                  duration: Duration(milliseconds: 500),
                ),
              );
            }
            kartEslestirmeSecili1 = null;
            kartEslestirmeSecili2 = null;
            setState(() {});
          });
        }
        return;
    }

    setState(() {});

    if (dogru) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Harika! Doğru! Skor: $yeniSkor"),
          backgroundColor: Sabitler.dogruRenk,
          duration: const Duration(milliseconds: 800),
        ),
      );
      Future.delayed(const Duration(milliseconds: 900), () => oyunuBaslat(oyunTipi));
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

  int getSkor(String oyunTipi) {
    switch (oyunTipi) {
      case 'renk':
        return renkSkor;
      case 'hayvan':
        return hayvanSkor;
      case 'meyve':
        return meyveSkor;
      case 'sayi':
        return sayiSkor;
      case 'sekil':
        return sekilSkor;
      case 'duygu':
        return duyguSkor;
      case 'organ':
        return organSkor;
      case 'ulasim':
        return ulasimSkor;
      case 'kart':
        return kartEslestirmeSkor;
      default:
        return 0;
    }
  }

  Widget oyunIcerik() {
    if (secilenOyun == null) {
      final oyunlar = [
        {'baslik': 'Renkler', 'ikon': '🎨', 'renk': Colors.red, 'tip': 'renk'},
        {'baslik': 'Hayvanlar', 'ikon': '🦁', 'renk': Colors.orange, 'tip': 'hayvan'},
        {'baslik': 'Meyveler', 'ikon': '🍎', 'renk': Colors.green, 'tip': 'meyve'},
        {'baslik': 'Sayılar', 'ikon': '🔢', 'renk': Colors.blue, 'tip': 'sayi'},
        {'baslik': 'Şekiller', 'ikon': '📐', 'renk': Colors.purple, 'tip': 'sekil'},
        {'baslik': 'Duygular', 'ikon': '😊', 'renk': Colors.pink, 'tip': 'duygu'},
        {'baslik': 'Organlar', 'ikon': '❤️', 'renk': Colors.teal, 'tip': 'organ'},
        {'baslik': 'Ulaşım', 'ikon': '🚗', 'renk': Colors.indigo, 'tip': 'ulasim'},
        {'baslik': 'Kart Eşleştirme', 'ikon': '🃏', 'renk': Colors.amber, 'tip': 'kart'},
      ];

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: oyunlar.length,
          itemBuilder: (context, index) {
            final oyun = oyunlar[index];
            return _buildOyunKarti(
              baslik: oyun['baslik'] as String,
              ikon: oyun['ikon'] as String,
              renk: oyun['renk'] as Color,
              onTap: () {
                final tip = oyun['tip'] as String;
                if (tip == 'ulasim') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const UlasimOyunu()));
                } else if (tip == 'kart') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const KartEslestirmeOyunu()));
                } else {
                  oyunuBaslat(tip);
                }
              },
            );
          },
        ),
      );
    }

    String baslik = '';
    String soru = '';
    List<Widget> secenekWidgets = [];

    switch (secilenOyun!) {
      case 'renk':
        baslik = "Renkleri Bul";
        soru = "${renkler[renkHedefIndeks]['ad']} nerede?";
        secenekWidgets = List.generate(4, (index) {
          int itemIndeks = renkSecenekler[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index > 0 ? 8 : 0,
                right: index < 3 ? 8 : 0,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 - (_animationController.value * 0.1),
                      child: child,
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => kontrolEt('renk', itemIndeks),
                      borderRadius: BorderRadius.circular(28),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              renkler[itemIndeks]['renk'],
                              renkler[itemIndeks]['renk'].withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white, width: 6),
                          boxShadow: [
                            BoxShadow(
                              color: renkler[itemIndeks]['renk'].withOpacity(0.4),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.25),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
        break;

      case 'hayvan':
        baslik = "Hayvanları Tanı";
        soru = "Hangisi ${hayvanlar[hayvanHedef]['ad']}?";
        secenekWidgets = List.generate(4, (index) {
          int id = hayvanSecenekler[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index > 0 ? 8 : 0,
                right: index < 3 ? 8 : 0,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 - (_animationController.value * 0.1),
                      child: child,
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => kontrolEt('hayvan', id),
                      borderRadius: BorderRadius.circular(28),
                      splashColor: Colors.orange.shade200,
                      highlightColor: Colors.orange.shade100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.orange.shade100,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.orange.shade400,
                            width: 5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.35),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 0.8,
                              colors: [
                                Colors.orange.shade50.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                hayvanlar[id]['emoji']!,
                                style: const TextStyle(fontSize: 120),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
        break;

      case 'meyve':
        baslik = "Meyve Bahçesi";
        soru = "Hadi ${meyveler[meyveHedef]['ad']}'yı bul!";
        secenekWidgets = List.generate(4, (index) {
          int id = meyveSecenekler[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index > 0 ? 8 : 0,
                right: index < 3 ? 8 : 0,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 - (_animationController.value * 0.1),
                      child: child,
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => kontrolEt('meyve', id),
                      borderRadius: BorderRadius.circular(28),
                      splashColor: Colors.green.shade200,
                      highlightColor: Colors.green.shade100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.green.shade100,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.green.shade400,
                            width: 5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.35),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 0.8,
                              colors: [
                                Colors.green.shade50.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                meyveler[id]['emoji']!,
                                style: const TextStyle(fontSize: 120),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
        break;

      case 'sayi':
        baslik = "Sayıları Öğren";
        soru = "Sayı $sayiHedef nerede?";
        secenekWidgets = List.generate(4, (index) {
          int s = sayiSecenekler[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index > 0 ? 8 : 0,
                right: index < 3 ? 8 : 0,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 - (_animationController.value * 0.1),
                      child: child,
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => kontrolEt('sayi', s),
                      borderRadius: BorderRadius.circular(28),
                      splashColor: Colors.blue.shade200,
                      highlightColor: Colors.blue.shade100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade100,
                              Colors.white,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.blue.shade400,
                            width: 5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.35),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 0.8,
                              colors: [
                                Colors.blue.shade50.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "$s",
                                style: TextStyle(
                                  fontSize: 110,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                  shadows: [
                                    Shadow(
                                      color: Colors.blue.shade300,
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
        break;

      case 'sekil':
        baslik = "Şekil Bulmaca";
        soru = "${sekiller[sekilHedef]['ad']}'yi seç";
        secenekWidgets = List.generate(4, (index) {
          int id = sekilSecenekler[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index > 0 ? 8 : 0,
                right: index < 3 ? 8 : 0,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 - (_animationController.value * 0.1),
                      child: child,
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => kontrolEt('sekil', id),
                      borderRadius: BorderRadius.circular(28),
                      splashColor: Colors.purple.shade200,
                      highlightColor: Colors.purple.shade100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.purple.shade100,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.purple.shade400,
                            width: 5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.35),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 0.8,
                              colors: [
                                Colors.purple.shade50.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                sekiller[id]['emoji']!,
                                style: const TextStyle(fontSize: 120),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
        break;

      case 'duygu':
        baslik = "Duyguları Tanı";
        soru = "Kim ${duygular[duyguHedef]['ad']}?";
        secenekWidgets = List.generate(4, (index) {
          int id = duyguSecenekler[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index > 0 ? 8 : 0,
                right: index < 3 ? 8 : 0,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 - (_animationController.value * 0.1),
                      child: child,
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => kontrolEt('duygu', id),
                      borderRadius: BorderRadius.circular(28),
                      splashColor: Colors.pink.shade200,
                      highlightColor: Colors.pink.shade100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.pink.shade100,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.pink.shade400,
                            width: 5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.35),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 0.8,
                              colors: [
                                Colors.pink.shade50.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                duygular[id]['emoji']!,
                                style: const TextStyle(fontSize: 120),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
        break;

      case 'organ':
        baslik = "Organları Tanı";
        soru = "Hangisi ${organlar[organHedef]['ad']}?";
        secenekWidgets = List.generate(4, (index) {
          int id = organSecenekler[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index > 0 ? 8 : 0,
                right: index < 3 ? 8 : 0,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 - (_animationController.value * 0.1),
                      child: child,
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => kontrolEt('organ', id),
                      borderRadius: BorderRadius.circular(28),
                      splashColor: Colors.teal.shade200,
                      highlightColor: Colors.teal.shade100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.teal.shade100,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.teal.shade400,
                            width: 5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.35),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 0.8,
                              colors: [
                                Colors.teal.shade50.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                organlar[id]['emoji']!,
                                style: const TextStyle(fontSize: 120),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
        break;

      case 'ulasim':
        baslik = "Ulaşım Araçları";
        soru = "Hangisi ${ulasimAraclari[ulasimHedef]['ad']}?";
        secenekWidgets = List.generate(4, (index) {
          int id = ulasimSecenekler[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index > 0 ? 8 : 0,
                right: index < 3 ? 8 : 0,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 - (_animationController.value * 0.1),
                      child: child,
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => kontrolEt('ulasim', id),
                      borderRadius: BorderRadius.circular(28),
                      splashColor: Colors.indigo.shade200,
                      highlightColor: Colors.indigo.shade100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.indigo.shade100,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.indigo.shade400,
                            width: 5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.withOpacity(0.35),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 0.8,
                              colors: [
                                Colors.indigo.shade50.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                ulasimAraclari[id]['emoji']!,
                                style: const TextStyle(fontSize: 120),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
        break;

      case 'kart':
        baslik = "Kart Eşleştirme";
        soru = "Aynı kartları bul ve eşleştir!";
        secenekWidgets = List.generate(12, (index) {
          final kartAcik = kartEslestirmeAcik[index];
          final kartEslesmis = kartEslestirmeEslesen.contains(index);
          final emoji = kartEslestirmeKartlar[index]['emoji'] as String;
          
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index % 3 > 0 ? 4 : 0,
                right: index % 3 < 2 ? 4 : 0,
                top: index ~/ 3 > 0 ? 4 : 0,
                bottom: index ~/ 3 < 3 ? 4 : 0,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: kartEslesmis ? null : () => kontrolEt('kart', index),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: kartEslesmis || kartAcik
                              ? [
                                  Colors.amber.shade100,
                                  Colors.white,
                                ]
                              : [
                                  Colors.amber.shade300,
                                  Colors.amber.shade400,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: kartEslesmis
                              ? Colors.green.shade400
                              : Colors.amber.shade500,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: kartEslesmis || kartAcik
                            ? FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 50),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : const Icon(
                                Icons.help_outline,
                                size: 50,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
        break;
    }

    if (secilenOyun == 'kart') {
      return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.amber.shade600,
                    Colors.amber.shade700,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                soru,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    final kartAcik = kartEslestirmeAcik[index];
                    final kartEslesmis = kartEslestirmeEslesen.contains(index);
                    final emoji = kartEslestirmeKartlar[index]['emoji'] as String;
                    
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: kartEslesmis ? null : () => kontrolEt('kart', index),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: kartEslesmis || kartAcik
                                  ? [
                                      Colors.amber.shade100,
                                      Colors.white,
                                    ]
                                  : [
                                      Colors.amber.shade300,
                                      Colors.amber.shade400,
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: kartEslesmis
                                  ? Colors.green.shade400
                                  : Colors.amber.shade500,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: kartEslesmis || kartAcik
                                ? FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      emoji,
                                      style: const TextStyle(fontSize: 50),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : const Icon(
                                    Icons.help_outline,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2196F3).withOpacity(0.9),
                  const Color(0xFF2196F3).withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2196F3).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              soru,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: secenekWidgets,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Sabitler.arkaPlan,
      appBar: AppBar(
        title: Text(
          secilenOyun == null ? 'Öğrenme Zamanı' : _getOyunBaslik(secilenOyun!),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2196F3),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: secilenOyun != null
            ? [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Skor: ${getSkor(secilenOyun!)}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      secilenOyun = null;
                    });
                  },
                ),
              ]
            : null,
      ),
      body: oyunIcerik(),
    );
  }

  String _getOyunBaslik(String oyunTipi) {
    switch (oyunTipi) {
      case 'renk':
        return 'Renkleri Bul';
      case 'hayvan':
        return 'Hayvanları Tanı';
      case 'meyve':
        return 'Meyve Bahçesi';
      case 'sayi':
        return 'Sayıları Öğren';
      case 'sekil':
        return 'Şekil Bulmaca';
      case 'duygu':
        return 'Duyguları Tanı';
      case 'organ':
        return 'Organları Tanı';
      case 'ulasim':
        return 'Ulaşım Araçları';
      case 'kart':
        return 'Kart Eşleştirme';
      default:
        return 'Öğrenme Zamanı';
    }
  }

  Widget _buildOyunKarti({
    required String baslik,
    required String ikon,
    required Color renk,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              renk.withOpacity(0.9),
              renk.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: renk.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    ikon,
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

