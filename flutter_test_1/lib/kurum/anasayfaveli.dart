import 'package:flutter/material.dart';
import '../main.dart';

class AnasayfaPageVeli extends StatelessWidget {
  const AnasayfaPageVeli({super.key, this.ad, this.email, this.tip});

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
            // 🔹 ANA SAYFA KUTUSU (SOLDA)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Ana Sayfa",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 🔹 AD KUTUSU (SAĞDA)
            if (ad != null && ad!.isNotEmpty)
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

        // 🔹 LOGOUT BUTONU (ÇERÇEVELİ)
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
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
              Text(
                'Özel öğrenci takip uygulamımız hakkında genel bilgilendirme yeri yazılacaktır',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 94, 94, 94),
                ),
              ),
            ],
          ),
        ),
      ),

      // body: SafeArea(
      //   child: Padding(
      //     padding: const EdgeInsets.all(24.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         const Text(
      //           'Hoş Geldiniz!',
      //           style: TextStyle(
      //             fontSize: 32,
      //             fontWeight: FontWeight.bold,
      //             color: Colors.black,
      //           ),
      //         ),
      //         const SizedBox(height: 16),
      //         if (email != null && email!.isNotEmpty) ...[
      //           Text(
      //             'Email: $email',
      //             style: const TextStyle(fontSize: 18, color: Colors.grey),
      //           ),
      //           const SizedBox(height: 8),
      //         ],
      //         if (ad != null && ad!.isNotEmpty) ...[
      //           Text(
      //             'Ad: $ad',
      //             style: const TextStyle(fontSize: 18, color: Colors.grey),
      //           ),
      //           const SizedBox(height: 8),
      //         ],
      //         if (tip != null && tip!.isNotEmpty) ...[
      //           Text(
      //             'Tip: $tip',
      //             style: const TextStyle(fontSize: 18, color: Colors.grey),
      //           ),
      //         ],
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
