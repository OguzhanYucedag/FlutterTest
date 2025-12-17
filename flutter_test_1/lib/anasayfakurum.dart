import 'package:flutter/material.dart';
//import 'main.dart'; kullanmadım

class AnasayfaPageKurum extends StatelessWidget {
  const AnasayfaPageKurum({super.key, this.ad, this.email, this.tip});//tanımladığım nesleler giriş bilgilerini tutar

  final String? ad;
  final String? email;
  final String? tip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
  appBar: AppBar(
    backgroundColor: Colors.orange,
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
        // Ad kutusu
        if (ad != null && ad!.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              ad!,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    ),
    actions: [//hamburger menü yapısı
      Container(
        width: 55,
        height: 55,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          border: Border.all(color: Colors.black, width: 1.5),
          shape: BoxShape.circle,
        ),
        child: PopupMenuButton<String>(
          iconSize: 40,
          icon: const Icon(Icons.menu, color: Colors.black, size: 33),
          onSelected: (String value) {
            // Seçilen menü öğesine göre işlem yapılabilir
            ScaffoldMessenger.of(context).showSnackBar(//seçilen değeri mesaj olarak gösteriyor 
              SnackBar(content: Text('$value seçildi')),//seçilen değer value olarak tutuluyor 
            );
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Öğretmen Ayarları',
              child: Text('Öğretmen Ayarları'),
            ),
            const PopupMenuItem<String>(
              value: 'Öğrenci Ayarları',
              child: Text('Öğrenci Ayarları'),
            ),
            const PopupMenuItem<String>(
              value: 'Profil Ayarları',
              child: Text('Profil Ayarları'),
            ),
          ],
        ),
      ),
    ],
  ),
      //---------------------------Genel Bilgilendirme Kısmı----------------------

      body: SafeArea(
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
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Özel öğrenci takip uygulamımız hakkında genel bilgilendirme yeri yazılacaktır',style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 94, 94, 94)),),
              ],  
            ),
          ),
        ),

      );
  }
}
