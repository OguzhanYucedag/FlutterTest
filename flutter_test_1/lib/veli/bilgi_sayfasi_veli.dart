import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BilgiSayfasiVeli extends StatefulWidget {
  final String? ad;
  final String? email;
  final String? tip;
  final String? ogrenciAdi;
  final String? sinif;
  final String? ogretmenAdi;

  const BilgiSayfasiVeli({
    super.key,
    this.ad,
    this.email,
    this.tip,
    this.ogrenciAdi,
    this.sinif,
    this.ogretmenAdi,
  });

  @override
  State<BilgiSayfasiVeli> createState() => _BilgiSayfasiVeliState();
}

class _BilgiSayfasiVeliState extends State<BilgiSayfasiVeli> {
  String? _fetchedOgrenciAdi;

  @override
  void initState() {
    super.initState();
    _fetchOgrenciAdi();
  }

  Future<void> _fetchOgrenciAdi() async {
    if (widget.ad == null) return;

    try {
      // 1. 'veliler' collection'unda 'kullanıcıAd' field'ı widget.ad ile eşleşen dökümanı bul
      final veliQuery = await FirebaseFirestore.instance
          .collection('veliler')
          .where('kullanıcıAd', isEqualTo: widget.ad)
          .limit(1)
          .get();

      if (veliQuery.docs.isEmpty) {
        debugPrint('Veli bulunamadı: ${widget.ad}');
        return;
      }

      // 'veliTelefon' bilgisini al
      final veliData = veliQuery.docs.first.data();
      final String? veliTelefon = veliData['veliTelefon'];

      if (veliTelefon == null) {
        debugPrint('Veli telefonu bulunamadı');
        return;
      }

      // 2. 'ogrenciler' collection'unda 'VeliNumarası' field'ı veliTelefon ile eşleşen dökümanı bul
      final ogrenciQuery = await FirebaseFirestore.instance
          .collection('ogrenciler')
          .where(
            'VeliNumarası',
            isEqualTo: veliTelefon,
          ) // Field adı user isteğine göre 'VeliNumarası'
          .limit(1)
          .get();

      if (ogrenciQuery.docs.isNotEmpty) {
        // 'kullanıcıAd' değerini al (öğrenci adı)
        final ogrenciData = ogrenciQuery.docs.first.data();
        final String? ogrenciAdi = ogrenciData['kullanıcıAd'];

        if (mounted && ogrenciAdi != null) {
          setState(() {
            _fetchedOgrenciAdi = ogrenciAdi;
          });
        }
      } else {
        debugPrint('Öğrenci bulunamadı (Veli No: $veliTelefon)');
      }
    } catch (e) {
      debugPrint('Hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Öğrenci Bilgi Paneli',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 4,
        shadowColor: Colors.blue.withOpacity(0.3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hoşgeldiniz Kartı
                _buildWelcomeCard(),
                const SizedBox(height: 24),

                // Öğrenci Bilgileri
                _buildSectionTitle('Öğrenci Bilgileri'),
                const SizedBox(height: 12),
                _buildStudentInfoCard(),
                const SizedBox(height: 24),

                // Önemli Bilgiler
                _buildSectionTitle('Önemli Bilgiler'),
                const SizedBox(height: 12),
                _buildImportantInfo(),
                const SizedBox(height: 24),

                // İletişim Bilgileri
                _buildContactCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.school,
                  color: Color(0xFF2196F3),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hoş Geldiniz, ${widget.ad}!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Özel Eğitim Takip Sistemine erişiminiz sağlandı.',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '1. Kademe özel eğitim öğrencisinin gelişimini takip etmek için tüm araçlara buradan ulaşabilirsiniz.',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                color: Color(0xFF2196F3),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Öğrenci',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _fetchedOgrenciAdi ?? widget.ogrenciAdi ?? 'Bilgi Yok',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.class_outlined,
                color: Color(0xFF2196F3),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sınıf',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.sinif ?? 'Bilgi Yok',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.supervised_user_circle_outlined,
                color: Color(0xFF2196F3),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sınıf Öğretmeni',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.ogretmenAdi ?? 'Bilgi Yok',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImportantInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFF2196F3),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Önemli Notlar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '1. Kademe Özel Eğitim Öğrencileri İçin:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoItem('• Gelişim raporları her ayın sonunda güncellenir'),
          _buildInfoItem('• BEP toplantıları dönem başında planlanır'),
          _buildInfoItem('• Ödev takibi her gün saat 17:00\'a kadar yapılır'),
          _buildInfoItem(
            '• Acil durumlarda öğretmen ile doğrudan iletişim kurulabilir',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'İletişim & Destek',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.email_outlined,
                color: Color(0xFF2196F3),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.email ?? 'bilgi@okul.edu.tr',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                color: Color(0xFF2196F3),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                '0 (XXX) XXX XX XX',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Destek sayfasına yönlendirme
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.support_agent, size: 20, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Destek Talep Et',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
