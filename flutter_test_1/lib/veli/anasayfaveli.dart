import 'package:flutter/material.dart';
import 'odevlerim_veli.dart';
import 'oyunlarim_veli.dart';
import 'bilgi_sayfasi_veli.dart';
import 'ilerleyisim_veli.dart';
import 'ayarlar_veli.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AnasayfaPageVeli extends StatefulWidget {
  const AnasayfaPageVeli({super.key, this.ad, this.email, this.tip});

  final String? ad;
  final String? email;
  final String? tip;

  @override
  State<AnasayfaPageVeli> createState() => _AnasayfaPageVeliState();
}

class _AnasayfaPageVeliState extends State<AnasayfaPageVeli> {
  int _selectedIndex = 2; // Başlangıçta Bilgi Sayfası (ortadaki) açık olsun
  String? _fetchedOgrenciAdi;
  String? _sinif; // Sınıf bilgisini de çekebiliriz

  @override
  void initState() {
    super.initState();
    _fetchOgrenciData();
  }

  Future<void> _fetchOgrenciData() async {
    if (widget.ad == null) return;

    try {
      // 1. 'veliler' collection'unda 'kullanıcıAd' field'ı widget.ad ile eşleşen dökümanı bul
      final veliQuery = await FirebaseFirestore.instance
          .collection('veliler')
          .where('kullanıcıAd', isEqualTo: widget.ad)
          .limit(1)
          .get();

      if (veliQuery.docs.isEmpty) {
        debugPrint('Veli bulunamadı: ${widget.ad}');
        return;
      }

      // 'veliTelefon' bilgisini al
      final veliData = veliQuery.docs.first.data();
      final String? veliTelefon = veliData['veliTelefon'];

      if (veliTelefon == null) {
        debugPrint('Veli telefonu bulunamadı');
        return;
      }

      // 2. 'ogrenciler' collection'unda 'VeliNumarası' field'ı veliTelefon ile eşleşen dökümanı bul
      final ogrenciQuery = await FirebaseFirestore.instance
          .collection('ogrenciler')
          .where('VeliNumarası', isEqualTo: veliTelefon)
          .limit(1)
          .get();

      if (ogrenciQuery.docs.isNotEmpty) {
        final ogrenciData = ogrenciQuery.docs.first.data();
        if (mounted) {
          setState(() {
            _fetchedOgrenciAdi = ogrenciData['kullanıcıAd'];
            _sinif = ogrenciData['sınıf']; // Eğer sınıf bilgisi varsa
          });
        }
      }
    } catch (e) {
      debugPrint('Hata oluştu: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sayfaları build içinde oluşturuyoruz ki state güncellenince onlar da güncellensin
    final List<Widget> pages = [
      OdevlerimVeli(ogrenciAdi: _fetchedOgrenciAdi, sinif: _sinif),
      const OyunlarimVeli(),
      BilgiSayfasiVeli(
        ad: widget.ad,
        email: widget.email,
        tip: widget.tip,
        ogrenciAdi: _fetchedOgrenciAdi,
      ),
      const IlerleyisimVeli(),
      const AyarlarVeli(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Ödevlerim'),
          BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Oyunlarım'),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Bilgi Sayfası',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'İlerleyişim',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2196F3), // Blue Theme
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }
}
