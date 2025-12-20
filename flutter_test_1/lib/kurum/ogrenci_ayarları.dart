import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OgrenciAyarlariPage extends StatefulWidget {
  const OgrenciAyarlariPage({super.key, this.baglikurum});

  final String? baglikurum;

  @override
  State<OgrenciAyarlariPage> createState() => _OgrenciAyarlariPageState();
}

class _OgrenciAyarlariPageState extends State<OgrenciAyarlariPage> {
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _soyadController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSaving = false;
  final List<_OgrenciKaydi> _ogrenciler = [];
  bool _ogrenciListYukleniyor = false;

  @override
  void initState() {
    super.initState();
    _ogrencileriGetir();
  }

  @override
  void dispose() {
    _adController.dispose();
    _soyadController.dispose();
    _telefonController.dispose();
    _sifreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Açık gri arka plan
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4CAF50), // Green 500
                      Color(0xFF388E3C), // Green 700
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              title: const Text(
                'Öğrenci Ayarları',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black26,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Form Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF4CAF50,
                                ).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                    0xFF4CAF50,
                                  ).withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.school_outlined,
                                color: Color(0xFF4CAF50),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Öğrenci Bilgileri',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                Text(
                                  'Öğrenci bilgilerini giriniz',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Form Fields
                        _buildTextField(
                          controller: _adController,
                          label: 'Öğrenci Adı',
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _soyadController,
                          label: 'Soyadı',
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _telefonController,
                          label: 'Veli Telefon Numarası',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),

                        _buildPasswordField(),
                        const SizedBox(height: 24),

                        // Save Button
                        _buildSaveButton(),
                        const SizedBox(height: 16),

                        // Kayıtlı öğrenciler listesi
                        _buildOgrenciListeAlani(),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: Color(0xFF333333)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
          prefixIcon: Icon(icon, color: const Color(0xFF4CAF50)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          filled: true,
          fillColor: const Color(0xFF4CAF50).withValues(alpha: 0.05),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
        ),
      ),
      child: TextField(
        controller: _sifreController,
        obscureText: _obscurePassword,
        style: const TextStyle(fontSize: 15, color: Color(0xFF333333)),
        decoration: InputDecoration(
          labelText: 'Şifre Oluştur',
          labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
          prefixIcon: const Icon(
            Icons.lock_outline_rounded,
            color: Color(0xFF4CAF50),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF4CAF50),
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          filled: true,
          fillColor: const Color(0xFF4CAF50).withValues(alpha: 0.05),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSaving ? null : veliVarmi,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: Colors.green.withValues(alpha: 0.3),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_alt_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Öğrenci Kaydet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildOgrenciListeAlani() {
    if (_ogrenciListYukleniyor) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
        ),
      );
    }

    if (_ogrenciler.isEmpty) {
      return const Text(
        'Bu kuruma ait öğrenci bulunamadı.',
        style: TextStyle(color: Color(0xFF546E7A)),
      );
    }

    return Column(
      children: _ogrenciler.map(_buildOgrenciSatiri).toList(),
    );
  }

  Widget _buildOgrenciSatiri(_OgrenciKaydi ogrenci) {
    final controller = TextEditingController(text: ogrenci.ad);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Kayıtlı Öğrenci',
          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF4CAF50)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () => _ogrenciSil(ogrenci.id),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
            ),
          ),
          filled: true,
          fillColor: const Color(0xFF4CAF50).withValues(alpha: 0.05),
        ),
      ),
    );
  }

  Future<void> veliVarmi() async {
    final numara = _telefonController.text.trim();

    if (numara.isEmpty) {
      _showSnackBar('Veli telefon numarası giriniz', Colors.orange);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final sorgu = await FirebaseFirestore.instance
          .collection('veliler')
          .where('veliTelefon', isEqualTo: numara)
          .limit(1)
          .get();

      if (sorgu.docs.isNotEmpty) {
        await veriOgrenciEkle();
      } else {
        _showSnackBar('Bu telefon numarasına ait veli bulunamadı', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Hata: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> veriOgrenciEkle() async {
    final ad = _adController.text.trim();
    final soyad = _soyadController.text.trim();
    final numara = _telefonController.text.trim();
    final sifre = _sifreController.text.trim();

    if (ad.isEmpty ||
        soyad.isEmpty ||
        numara.isEmpty ||
        sifre.isEmpty) {
      _showSnackBar('Lütfen tüm alanları doldurun', Colors.orange);
      return;
    }

    setState(() => _isSaving = true);

    final Map<String, dynamic> ogrenciVerisi = {
      'kullanıcıAd': ad,
      'kullanıcıSoyad': soyad,
      'VeliNumarası': numara,
      'kullanıcıŞifre': sifre,
      'bagliOlduguKurum': widget.baglikurum ?? '',
      'tip': 'ogrenci',
      'olusturmaZamani': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('ogrenciler').add(ogrenciVerisi);

      if (!mounted) return;

      _showSnackBar('Öğrenci başarıyla eklendi', Colors.green);

      _adController.clear();
      _soyadController.clear();
      _telefonController.clear();
      _sifreController.clear();

      await _ogrencileriGetir();
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Hata: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _ogrencileriGetir() async {
    setState(() => _ogrenciListYukleniyor = true);

    try {
      final sorgu = await FirebaseFirestore.instance
          .collection('ogrenciler')
          .where('bagliOlduguKurum', isEqualTo: widget.baglikurum ?? '')
          .get();

      if (!mounted) return;
      setState(() {
        _ogrenciler
          ..clear()
          ..addAll(
            sorgu.docs
                .map(
                  (d) => _OgrenciKaydi(
                    id: d.id,
                    ad: (d.data()['kullanıcıAd'] ?? '').toString(),
                  ),
                )
                .toList(),
          );
      });
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Öğrenciler alınamadı: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() => _ogrenciListYukleniyor = false);
      }
    }
  }

  Future<void> _ogrenciSil(String id) async {
    try {
      await FirebaseFirestore.instance.collection('ogrenciler').doc(id).delete();
      await _ogrencileriGetir();
      _showSnackBar('Öğrenci silindi', Colors.green);
    } catch (e) {
      _showSnackBar('Silme hatası: $e', Colors.red);
    }
  }
}

class _OgrenciKaydi {
  _OgrenciKaydi({required this.id, required this.ad});

  final String id;
  final String ad;
}
