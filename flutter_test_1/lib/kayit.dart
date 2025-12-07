import 'package:flutter/material.dart';

class KayitPage extends StatefulWidget {
  const KayitPage({super.key});

  @override
  State<KayitPage> createState() => _KayitPageState();
}

class _KayitPageState extends State<KayitPage> {
  

  late String ad, sifre, email;

  adAl(adTutucu) {
    this.ad = adTutucu;
  }

  emailAl(emailTutucu) {
    this.email = emailTutucu;
  }

  sifreAl(sifreTutucu) {
    this.sifre = sifreTutucu;
  }

  // Görsel durum için değişkenler (Sabit kalacaklar)
  final bool _obscurePassword = true;
  final bool _obscureConfirmPassword = true;
  int _selectedOption = 0; // 0: Kurum Kaydı seçili varsayılan

  @override
  // Tüm kayıt ve doğrulama fonksiyonları silindi.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık Bölümü
              const Text(
                'Hesap Bilgilerinizi Giriniz',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // İsim Alanı
              TextField(
                onChanged: (String adTutucu) {
                  adAl(adTutucu);
                },
                decoration: InputDecoration(
                  labelText: _selectedOption == 0 ? 'Kurum Adı' : 'Ad Soyad',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Email Alanı
              TextField(
                onChanged: (String emailTutucu) {
                  emailAl(emailTutucu);
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),

              // Şifre Alanı
              TextField(
                onChanged: (String sifreTutucu) {
                  sifreAl(sifreTutucu);
                },
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // İşlev kaldırıldı
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Şifre Tekrar Alanı
              TextField(
                decoration: InputDecoration(
                  labelText: 'Şifre Tekrar',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // İşlev kaldırıldı
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Spacer(),

              // Seçim Butonları (Kurum / Veli)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Birinci Buton (Kurum)
                  Expanded(
                    child: Material(
                      color: _selectedOption == 0 ? const Color.fromARGB(255, 96, 96, 96) : Colors.transparent,
                      borderRadius: BorderRadius.circular(32),
                      child: InkWell(
                        onTap: () {

                          setState(() {
                            _selectedOption = 0;
                          });
                           
                        },
                        borderRadius: BorderRadius.circular(32),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Kurum Kaydı',
                            style: TextStyle(
                              color: _selectedOption == 0 ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // İkinci Buton (Veli)
                  Expanded(
                    child: Material(
                      color: _selectedOption == 1 ? const Color.fromARGB(255, 96, 96, 96) : Colors.transparent,
                      borderRadius: BorderRadius.circular(32),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedOption = 1;
                          });
                        },
                        borderRadius: BorderRadius.circular(32),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Veli Kaydı',
                            style: TextStyle(
                              color: _selectedOption == 1 ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Kayıt Ol Butonu
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: ()  {
                      //Kayıt Butonu İşlevi
                    },
                    borderRadius: BorderRadius.circular(32),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      alignment: Alignment.center,
                      child: const Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void veriEkle() {
    //veri ekleme yolu
    // DocumentReference veriYolu = FirebaseFirestore.instance
    //     .collection("Kurum")
    //     .doc(id);

    //Çoklu Veri için map
    Map<String, dynamic> kurumlar = {
      "kurumAd": ad,
      "kurumEmail": email,
      "kurumŞifre": sifre,
    };

    //veriyi veri tabanına ekle
    // veriYolu.set(kurumlar).whenComplete(() {
    //   Fluttertoast.showToast(msg: id + "ID'li kurum eklendi");
    // });
  }
}
