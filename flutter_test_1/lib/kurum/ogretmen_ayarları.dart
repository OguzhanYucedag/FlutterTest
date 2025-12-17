import 'package:flutter/material.dart';

class OgretmenAyarlariPage extends StatelessWidget {
  const OgretmenAyarlariPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Arka plan: Hafif gri
      appBar: AppBar(
        title: const Text('Öğretmen Ayarları'),
        backgroundColor: const Color(0xFF1565C0), // AppBar: Okul mavisi
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Öğretmen Yönetimi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1), // Başlık: Koyu mavi
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Öğretmen bilgilerini girerek kaydedebilirsiniz.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const TextField(//Öğretmen Adı alanı
                      //onChanged: ogretmenAdAl,
                      decoration: InputDecoration(
                        labelText: 'Öğretmen Adı',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const TextField(//Öğretmen Soyadı alanı
                      //onChanged: ogretmenSoyadAl,
                      decoration: InputDecoration(
                        labelText: 'Öğretmen Soyadı',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const TextField(//Öğretmen Email alanı
                      //onChanged: ogretmenEmailAl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const TextField(//Öğretmen Numara alanı
                      //onChanged: ogretmenNumaraAl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Numara',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const TextField(//Öğretmen Şifre alanı
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: kayıt işlemi eklenecek
                          veriOgretmenEkle();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Kaydet',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> veriOgretmenEkle() async {
    
    
    
  }



  
}
