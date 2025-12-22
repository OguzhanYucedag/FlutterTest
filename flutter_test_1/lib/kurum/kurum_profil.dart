import 'package:flutter/material.dart';

class KurumProfilPage extends StatefulWidget {
  const KurumProfilPage({super.key});

  @override
  State<KurumProfilPage> createState() => _KurumProfilPageState();
}

class _KurumProfilPageState extends State<KurumProfilPage> {
  // Text Editing Controllers
  final TextEditingController _kurumKoduAdiController = TextEditingController();
  final TextEditingController _kurumTuruController = TextEditingController();
  final TextEditingController _ogretimSekliController = TextEditingController();
  final TextEditingController _hizmetBolgesiController =
      TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _adresController = TextEditingController();

  @override
  void dispose() {
    _kurumKoduAdiController.dispose();
    _kurumTuruController.dispose();
    _ogretimSekliController.dispose();
    _hizmetBolgesiController.dispose();
    _telefonController.dispose();
    _adresController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8), // Açık yeşil arka plan
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
                      Color(0xFF4CAF50), // Yeşil 500
                      Color(0xFF388E3C), // Yeşil 700
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              title: const Text(
                'Kurum Profili',
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
                        color: Colors.green.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.green.withOpacity(0.1),
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
                                ).withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                    0xFF4CAF50,
                                  ).withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.business_outlined,
                                color: Color(0xFF4CAF50),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kurum Bilgileri',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263238),
                                  ),
                                ),
                                Text(
                                  'Kurum bilgilerinizi güncelleyin',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF546E7A),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Form Fields
                        _buildTextField(
                          controller: _kurumKoduAdiController,
                          label: 'Kurum Kodu ve Adı',
                          icon: Icons.school_outlined,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _kurumTuruController,
                          label: 'Kurum Türü',
                          icon: Icons.category_outlined,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _ogretimSekliController,
                          label: 'Öğretim Şekli',
                          icon: Icons.menu_book_outlined,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _hizmetBolgesiController,
                          label: 'Hizmet Bölgesi ve Alanı',
                          icon: Icons.map_outlined,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _telefonController,
                          label: 'Telefon',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _adresController,
                          label: 'Adres',
                          icon: Icons.location_on_outlined,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),

                        // Save Button
                        _buildSaveButton(),
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
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.5),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15, color: Color(0xFF37474F)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF2E7D32),
          ), // Darker green for label
          prefixIcon: Icon(icon, color: const Color(0xFF4CAF50)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          filled: true,
          fillColor: const Color(
            0xFF4CAF50,
          ).withOpacity(0.05), // Light green fill
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Kaydetme işlemi
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: Colors.green.withOpacity(0.3),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_alt_rounded, size: 20),
            SizedBox(width: 8),
            Text(
              'Bilgileri Kaydet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
