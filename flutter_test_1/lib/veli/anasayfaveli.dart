import 'package:flutter/material.dart';
import '../main.dart';

class AnasayfaPageVeli extends StatefulWidget {
  final String? ad;
  final String? email;
  final String? tip;

  const AnasayfaPageVeli({super.key, this.ad, this.email, this.tip});

  @override
  State<AnasayfaPageVeli> createState() => _AnasayfaPageVeliState();
}

class _AnasayfaPageVeliState extends State<AnasayfaPageVeli> {
  int _selectedIndex = 2; // Default to "Bilgi Sayfası" (Home/Info)

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const _OdevlerimPage(),
      const _OyunlarimPage(),
      _BilgiSayfasiPage(ad: widget.ad, email: widget.email), // Pass user info
      const _IlerleyisimPage(),
      const _AyarlarPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return "Ödevlerim";
      case 1:
        return "Oyunlarım";
      case 2:
        return "Ana Sayfa";
      case 3:
        return "İlerleyişim";
      case 4:
        return "Ayarlar";
      default:
        return "Ana Sayfa";
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color.fromARGB(255, 55, 107, 221);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🔹 SAYFA BAŞLIĞI (SOLDA)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getAppBarTitle(),
                style: const TextStyle(
                  color: primaryBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 🔹 AD KUTUSU (SAĞDA) - Sadece Bilgi Sayfası'nda veya her yerde gösterilebilir
            if (widget.ad != null && widget.ad!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.ad!,
                  style: const TextStyle(
                    color: primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          // Logout button matches theme
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // Blue theme for selection, Grey for unselected
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Ödevlerim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: 'Oyunlarım',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info), // Or Icons.home
            label: 'Bilgi',
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

// ---------------------------------------------------------------------------
// Placeholder Pages
// ---------------------------------------------------------------------------

class _OdevlerimPage extends StatelessWidget {
  const _OdevlerimPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Ödevlerim Sayfası',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _OyunlarimPage extends StatelessWidget {
  const _OyunlarimPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Oyunlarım Sayfası',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _BilgiSayfasiPage extends StatelessWidget {
  final String? ad;
  final String? email;

  const _BilgiSayfasiPage({this.ad, this.email});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hoş Geldiniz!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 55, 107, 221), // Blue title
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Özel öğrenci takip uygulamımız hakkında genel bil',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 94, 94, 94),
              ),
            ),
            // Optional: display extra info if needed, similar to old comments
            if (email != null) ...[
              const SizedBox(height: 20),
              Text("Email: $email", style: const TextStyle(color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }
}

class _IlerleyisimPage extends StatelessWidget {
  const _IlerleyisimPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'İlerleyişim Sayfası',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _AyarlarPage extends StatelessWidget {
  const _AyarlarPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Ayarlar Sayfası',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
