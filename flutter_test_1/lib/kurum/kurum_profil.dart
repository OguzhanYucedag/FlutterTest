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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Profil Ayarları'),
        backgroundColor: const Color(0xFF1565C0),
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kurum Bilgileri',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                const SizedBox(height: 24),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _kurumKoduAdiController,
                        label: 'Kurum Kodu ve Adı',
                        icon: Icons.school,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _kurumTuruController,
                        label: 'Kurum Türü',
                        icon: Icons.category,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _ogretimSekliController,
                        label: 'Öğretim Şekli',
                        icon: Icons.menu_book,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _hizmetBolgesiController,
                        label: 'Hizmet Bölgesi ve Alanı',
                        icon: Icons.map,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _telefonController,
                        label: 'Telefon',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _adresController,
                        label: 'Adres',
                        icon: Icons.location_on,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Kaydet Butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Kaydetme işlemi
                    },
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'Kaydet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
