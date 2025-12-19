import 'package:flutter/material.dart';
import 'odevlerim_veli.dart';
import 'oyunlarim_veli.dart';
import 'bilgi_sayfasi_veli.dart';
import 'ilerleyisim_veli.dart';
import 'ayarlar_veli.dart';

class AnasayfaPageVeli extends StatefulWidget {
  final String? ad;
  final String? email;
  final String? tip;

  const AnasayfaPageVeli({super.key, this.ad, this.email, this.tip});

  @override
  State<AnasayfaPageVeli> createState() => _AnasayfaPageVeliState();
}

class _AnasayfaPageVeliState extends State<AnasayfaPageVeli> {
  int _selectedIndex = 2; // Start with Bilgi Sayfasi (middle)

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const OdevlerimVeli(),
      const OyunlarimVeli(),
      BilgiSayfasiVeli(ad: widget.ad, email: widget.email, tip: widget.tip),
      const IlerleyisimVeli(),
      const AyarlarVeli(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Blue theme color matching the requested design
    const primaryBlue = Color.fromARGB(255, 55, 107, 221);

    return Scaffold(
      // using IndexedStack to preserve state of tabs
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Ödevlerim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: 'Oyunlarım',
          ),
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
      ),
    );
  }
}
