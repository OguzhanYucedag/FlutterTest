import 'package:flutter/material.dart';
import 'main.dart';

class AnasayfaPageKurum extends StatelessWidget {
  const AnasayfaPageKurum({super.key, this.ad, this.email, this.tip});

  final String? ad;
  final String? email;
  final String? tip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
  appBar: AppBar(
    backgroundColor: const Color(0xFFFFA94D),
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
        // 🔹 AD KUTUSU (SOLDA)
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
    actions: [
      PopupMenuButton<String>(
        icon: const Icon(Icons.menu, color: Colors.black),
        onSelected: (String value) {
          // Seçilen menü öğesine göre işlem yapılabilir
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$value seçildi')),
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
