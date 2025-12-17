import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OgretmenAyarlariPage extends StatefulWidget {
  const OgretmenAyarlariPage({super.key});

  @override
  State<OgretmenAyarlariPage> createState() => _OgretmenAyarlariPageState();
}

class _OgretmenAyarlariPageState extends State<OgretmenAyarlariPage> {
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _soyadController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numaraController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  bool _obscurePassword = true;
  final List<_OgretmenKaydi> _ogretmenler = [];
  bool _listeYukleniyor = false;

  @override
  void initState() {
    super.initState();
    _ogretmenleriGetir();
  }

  @override
  void dispose() {
    _adController.dispose();
    _soyadController.dispose();
    _emailController.dispose();
    _numaraController.dispose();
    _sifreController.dispose();
    super.dispose();
  }

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
        child: SingleChildScrollView(
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
                    TextField(
                      controller: _adController,
                      decoration: const InputDecoration(
                        labelText: 'Öğretmen Adı',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _soyadController,
                      decoration: const InputDecoration(
                        labelText: 'Öğretmen Soyadı',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _numaraController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Numara',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _sifreController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: veriOgretmenEkle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Kaydet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _listeYukleniyor
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _ogretmenler.length,
                            itemBuilder: (context, index) {
                              final ogretmen = _ogretmenler[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.25),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ogretmen.ad.isEmpty
                                          ? 'İsim yok'
                                          : ogretmen.ad,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          _ogretmenSil(ogretmen.id),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                    const SizedBox(height: 8),
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
    final ad = _adController.text.trim();
    final soyad = _soyadController.text.trim();
    final email = _emailController.text.trim();
    final numara = _numaraController.text.trim();
    final sifre = _sifreController.text.trim();

    if (ad.isEmpty ||
        soyad.isEmpty ||
        email.isEmpty ||
        numara.isEmpty ||
        sifre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }

    final emailKayitli = await _emailVarMi(email);
    if (emailKayitli) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bu e-posta zaten kayıtlı')),
      );
      return;
    }

    final Map<String, dynamic> ogretmenVerisi = {
      'kullanıcıAd': ad,
      'kullanıcıSoyad': soyad,
      'kullanıcıEmail': email,
      'kullanıcıNumara': numara,
      'kullanıcıŞifre': sifre,
      'tip': 'ogretmen',
      'olusturmaZamani': FieldValue.serverTimestamp(),
    };

    FirebaseFirestore.instance
        .collection('users')
        .add(ogretmenVerisi)
        .then((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Öğretmen kaydı eklendi')),
      );
      _adController.clear();
      _soyadController.clear();
      _emailController.clear();
      _numaraController.clear();
      _sifreController.clear();
      _ogretmenleriGetir();
    }).catchError((e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt eklenemedi: $e')),
      );
    });
  }

  Future<bool> _emailVarMi(String email) async {
    final sorgu = await FirebaseFirestore.instance
        .collection('users')
        .where('kullanıcıEmail', isEqualTo: email)
        .limit(1)
        .get();
    return sorgu.docs.isNotEmpty;
  }

  Future<void> _ogretmenleriGetir() async {
    setState(() {
      _listeYukleniyor = true;
    });

    try {
      final sorgu = await FirebaseFirestore.instance
          .collection('users')
          .where('tip', isEqualTo: 'ogretmen')
          .get();

      if (!mounted) return;
      setState(() {
        _ogretmenler
          ..clear()
          ..addAll(
            sorgu.docs
                .map(
                  (d) => _OgretmenKaydi(
                    id: d.id,
                    ad: (d.data()['kullanıcıAd'] ?? '').toString(),
                  ),
                )
                .toList(),
          );
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öğretmenler getirilemedi: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _listeYukleniyor = false;
      });
    }
  }

  Future<void> _ogretmenSil(String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).delete();
    await _ogretmenleriGetir();
  }
}

class _OgretmenKaydi {
  _OgretmenKaydi({required this.id, required this.ad});

  final String id;
  final String ad;
}
