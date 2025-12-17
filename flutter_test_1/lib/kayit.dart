import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class KayitPage extends StatefulWidget {
  const KayitPage({super.key});

  @override
  State<KayitPage> createState() => _KayitPageState();
}

class _KayitPageState extends State<KayitPage> {
  String ad = '', sifre = '', email = '', sifreTekrar = '';

  // Değiştirilebilir hale getirildi
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _selectedOption = 0; // 0: Kurum Kaydı seçili varsayılan

  adAl(adTutucu) {
    ad = adTutucu;
  }

  emailAl(emailTutucu) {
    email = emailTutucu;
  }

  sifreAl(sifreTutucu) {
    sifre = sifreTutucu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image with transparency
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/login_bg.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8),
                  BlendMode.lighten,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Geri dön butonu ve başlık
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hesap',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 55, 107, 221),
                              ),
                            ),
                            const Text(
                              'Bilgilerinizi Giriniz',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 55, 107, 221),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Ad Alanı
                  TextField(
                    onChanged: adAl,
                    decoration: InputDecoration(
                      labelText: _selectedOption == 0
                          ? 'Kurum Adı'
                          : 'Ad Soyad',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email
                  TextField(
                    onChanged: emailAl,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),

                  // Şifre
                  TextField(
                    onChanged: sifreAl,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Şifre Tekrar
                  TextField(
                    onChanged: (value) {
                      sifreTekrar = value;
                    },
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Şifre Tekrar',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Spacer(),

                  // Kurum / Veli butonları
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: _selectedOption == 0
                              ? Colors.blue
                              : Colors.transparent,
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
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Kurum Kaydı',
                                style: TextStyle(
                                  color: _selectedOption == 0
                                      ? Colors.white
                                      : Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Material(
                          color: _selectedOption == 1
                              ? Colors.blue
                              : Colors.transparent,
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
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Veli Kaydı',
                                style: TextStyle(
                                  color: _selectedOption == 1
                                      ? Colors.white
                                      : Colors.blue,
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

                  // Kayıt Ol butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      onPressed: veriEkle,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> veriEkle() async {
    if (ad.isEmpty || email.isEmpty || sifre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }

    if (sifre != sifreTekrar) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Şifreler eşleşmiyor')));
      return;
    }

    const String collection = 'users';
    final String adEtiketi = _selectedOption == 0 ? 'kurum adı' : 'veli adı';
    final String tip = _selectedOption == 0 ? 'kurum' : 'veli';

    final bool adKayitli = await _kayitVarMi(collection, 'kullanıcıAd', ad);
    if (adKayitli) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bu $adEtiketi zaten kayıtlı')));
      return;
    }

    final bool emailKayitli = await _kayitVarMi(
      collection,
      'kullanıcıEmail',
      email,
    );
    if (emailKayitli) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Bu e-posta zaten kayıtlı')));
      return;
    }

    final Map<String, dynamic> kurumlar = {
      "kullanıcıAd": ad,
      "kullanıcıEmail": email,
      "kullanıcıŞifre": sifre,
      "tip": tip,
      "olusturmaZamani": FieldValue.serverTimestamp(),
    };

    FirebaseFirestore.instance
        .collection(collection)
        .add(kurumlar)
        .then((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kayıt başarıyla eklendi')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()),
            (route) => false,
          );
        })
        .catchError((e) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Kayıt eklenemedi: $e')));
        });
  }

  Future<bool> _kayitVarMi(String collection, String alan, String deger) async {
    final sorgu = await FirebaseFirestore.instance
        .collection(collection)
        .where(alan, isEqualTo: deger)
        .limit(1)
        .get();
    return sorgu.docs.isNotEmpty;
  }
}
