import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OgretmenAyarlariPage extends StatefulWidget {
  const OgretmenAyarlariPage({super.key, this.baglikurum});

  final String? baglikurum;

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
  bool _isSaving = false;

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
      backgroundColor: const Color(0xFFF5F7FA), // Light blue-gray background
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
                'Öğretmen Yönetimi',
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
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: _ogretmenleriGetir,
              ),
            ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Form Card
                _buildFormCard(),
                const SizedBox(height: 24),

                // Teacher List Header
                _buildListHeader(),
                const SizedBox(height: 16),

                // Teacher List
                _buildTeacherList(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withValues(alpha: 0.15),
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
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_rounded,
                    color: Color(0xFF4CAF50),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yeni Öğretmen Ekle',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                    Text(
                      'Öğretmen bilgilerini girerek sistem',
                      style: TextStyle(fontSize: 14, color: Color(0xFF546E7A)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form Fields
            _buildTextField(
              controller: _adController,
              label: 'Öğretmen Adı',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _soyadController,
              label: 'Öğretmen Soyadı',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _emailController,
              label: 'E-posta Adresi',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _numaraController,
              label: 'Telefon Numarası',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            _buildPasswordField(),
            const SizedBox(height: 24),

            // Save Button
            _buildSaveButton(),
          ],
        ),
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
        style: const TextStyle(fontSize: 15, color: Color(0xFF37474F)),
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
        style: const TextStyle(fontSize: 15, color: Color(0xFF37474F)),
        decoration: InputDecoration(
          labelText: 'Şifre',
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
        onPressed: _isSaving ? null : veriOgretmenEkle,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
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
                height: 20,
                width: 20,
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
                    'Öğretmeni Kaydet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildListHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Kayıtlı Öğretmenler',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_ogretmenler.length} öğretmen',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1976D2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherList() {
    if (_listeYukleniyor) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
        ),
      );
    }

    if (_ogretmenler.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.green.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.group_outlined,
              size: 64,
              color: Colors.blueGrey.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'Henüz öğretmen kaydı bulunmuyor',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF546E7A),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Yukarıdaki formu doldurarak öğretmen ekleyebilirsiniz',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF78909C)),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _ogretmenler.map((ogretmen) {
        return _buildTeacherCard(ogretmen);
      }).toList(),
    );
  }

  Widget _buildTeacherCard(_OgretmenKaydi ogretmen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.green.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              ogretmen.ad.isNotEmpty ? ogretmen.ad[0] : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        title: Text(
          ogretmen.ad.isNotEmpty ? ogretmen.ad : 'İsimsiz Öğretmen',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF263238),
          ),
        ),
        subtitle: Text(
          ogretmen.email.isNotEmpty ? ogretmen.email : 'E-posta yok',
          style: const TextStyle(fontSize: 14, color: Color(0xFF546E7A)),
        ),
        trailing: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
              size: 20,
            ),
          ),
          onPressed: () => _showDeleteDialog(ogretmen),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(_OgretmenKaydi ogretmen) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Öğretmeni Sil'),
        content: Text(
          '${ogretmen.ad} adlı öğretmeni silmek istediğinize emin misiniz?',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'İptal',
              style: TextStyle(color: Color(0xFF546E7A)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _ogretmenSil(ogretmen.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sil'),
          ),
        ],
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
      _showSnackBar('Lütfen tüm alanları doldurun', Colors.orange);
      return;
    }

    if (!email.contains('@')) {
      _showSnackBar('Geçerli bir e-posta adresi giriniz', Colors.orange);
      return;
    }

    setState(() => _isSaving = true);

    final emailKayitli = await _emailVarMi(email);
    if (emailKayitli) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showSnackBar('Bu e-posta adresi zaten kayıtlı', Colors.red);
      return;
    }

    final Map<String, dynamic> ogretmenVerisi = {
      'kullanıcıAd': ad,
      'kullanıcıSoyad': soyad,
      'kullanıcıEmail': email,
      'kullanıcıNumara': numara,
      'kullanıcıŞifre': sifre,
      'bagliOlduguKurum': widget.baglikurum ?? '',
      'tip': 'ogretmen',
      'olusturmaZamani': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('ogretmenler').add(ogretmenVerisi);//ogretmenler koleksiyonuna ekle

      if (!mounted) return;

      _showSnackBar('Öğretmen başarıyla eklendi', Colors.green);

      _adController.clear();
      _soyadController.clear();
      _emailController.clear();
      _numaraController.clear();
      _sifreController.clear();

      await _ogretmenleriGetir();
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

  Future<bool> _emailVarMi(String email) async {
    final sorgu = await FirebaseFirestore.instance
        .collection('ogretmenler')//ogretmenler koleksiyonuna bakacak email kontrolü yapılacak. ama bir öğretmen tek yerde çalışmalı
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
          .collection('ogretmenler')//ogretmenler
          .where('tip', isEqualTo: 'ogretmen')
          .where('bagliOlduguKurum', isEqualTo: widget.baglikurum ?? '')
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
                    email: (d.data()['kullanıcıEmail'] ?? '').toString(),
                    soyad: (d.data()['kullanıcıSoyad'] ?? '').toString(),
                    numara: (d.data()['kullanıcıNumara'] ?? '').toString(),
                  ),
                )
                .toList(),
          );
      });
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Hata: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _listeYukleniyor = false;
        });
      }
    }
  }

  Future<void> _ogretmenSil(String id) async {
    try {
      await FirebaseFirestore.instance.collection('ogretmenler').doc(id).delete();//ogretmenler koleksiyonuna silinecek.

      if (!mounted) return;
      _showSnackBar('Öğretmen başarıyla silindi', Colors.green);

      await _ogretmenleriGetir();
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Silme hatası: $e', Colors.red);
    }
  }
}

class _OgretmenKaydi {
  _OgretmenKaydi({
    required this.id,
    required this.ad,
    this.email = '',
    this.soyad = '',
    this.numara = '',
  });

  final String id;
  final String ad;
  final String email;
  final String soyad;
  final String numara;
}
