import 'package:flutter/material.dart';

class IlerleyisimVeli extends StatelessWidget {
  final String? ogrenciAdi;
  final String? sinif;

  const IlerleyisimVeli({super.key, this.ogrenciAdi, this.sinif});

  @override
  Widget build(BuildContext context) {
    // Akademik alanlar ve ilerleyiş verileri
    final List<Map<String, dynamic>> akademikAlanlar = [
      {
        'id': 1,
        'ad': 'Akademik Alanlar',
        'icon': Icons.school_outlined,
        'renk': Colors.blue,
        'ilerleme': 75.0, // double olarak tanımla
        'aciklama': 'Temel akademik beceriler',
        'sonGuncelleme': '18.12.2023',
        'hedefler': [
          {'hedef': 'Rakamları tanıma', 'durum': 'tamamlandi'},
          {'hedef': 'Toplama işlemi', 'durum': 'devamEdiyor'},
          {'hedef': 'Çıkarma işlemi', 'durum': 'baslanmadi'},
        ],
      },
      {
        'id': 2,
        'ad': 'Dil ve İletişim Gelişimi',
        'icon': Icons.language_outlined,
        'renk': Colors.green,
        'ilerleme': 60.0,
        'aciklama': 'İfade ve anlama becerileri',
        'sonGuncelleme': '17.12.2023',
        'hedefler': [
          {'hedef': 'Basit cümle kurma', 'durum': 'tamamlandi'},
          {'hedef': 'Sesli okuma', 'durum': 'devamEdiyor'},
          {'hedef': 'Dinleme becerisi', 'durum': 'devamEdiyor'},
        ],
      },
      {
        'id': 3,
        'ad': 'Sosyal ve Duygusal Gelişim',
        'icon': Icons.people_outline,
        'renk': Colors.orange,
        'ilerleme': 85.0,
        'aciklama': 'Sosyal etkileşim becerileri',
        'sonGuncelleme': '16.12.2023',
        'hedefler': [
          {'hedef': 'Arkadaşlık kurma', 'durum': 'tamamlandi'},
          {'hedef': 'Duygu ifadesi', 'durum': 'tamamlandi'},
          {'hedef': 'Sıra bekleme', 'durum': 'devamEdiyor'},
        ],
      },
      {
        'id': 4,
        'ad': 'Öz Bakım ve Günlük Yaşam Becerileri',
        'icon': Icons.self_improvement_outlined,
        'renk': Colors.purple,
        'ilerleme': 45.0,
        'aciklama': 'Günlük yaşam becerileri',
        'sonGuncelleme': '15.12.2023',
        'hedefler': [
          {'hedef': 'El yıkama', 'durum': 'tamamlandi'},
          {'hedef': 'Ayakkabı bağlama', 'durum': 'devamEdiyor'},
          {'hedef': 'Düğme ilikleme', 'durum': 'baslanmadi'},
        ],
      },
      {
        'id': 5,
        'ad': 'Psikomotor Gelişim',
        'icon': Icons.directions_run_outlined,
        'renk': Colors.red,
        'ilerleme': 70.0,
        'aciklama': 'Hareket ve koordinasyon',
        'sonGuncelleme': '14.12.2023',
        'hedefler': [
          {'hedef': 'Çizgi çizme', 'durum': 'tamamlandi'},
          {'hedef': 'Top atma-tutma', 'durum': 'devamEdiyor'},
          {'hedef': 'Makas kullanma', 'durum': 'devamEdiyor'},
        ],
      },
      {
        'id': 6,
        'ad': 'Sanat ve Estetik',
        'icon': Icons.brush_outlined,
        'renk': Colors.pink,
        'ilerleme': 90.0,
        'aciklama': 'Sanatsal ifade becerileri',
        'sonGuncelleme': '13.12.2023',
        'hedefler': [
          {'hedef': 'Serbest boyama', 'durum': 'tamamlandi'},
          {'hedef': 'Renk karıştırma', 'durum': 'tamamlandi'},
          {'hedef': 'Şekil çizme', 'durum': 'devamEdiyor'},
        ],
      },
      {
        'id': 7,
        'ad': 'Destekleyici Eğitim Etkinlikleri',
        'icon': Icons.assistant_outlined,
        'renk': Colors.teal,
        'ilerleme': 55.0,
        'aciklama': 'Destekleyici öğrenme',
        'sonGuncelleme': '12.12.2023',
        'hedefler': [
          {'hedef': 'Eşleştirme oyunu', 'durum': 'tamamlandi'},
          {'hedef': 'Hafıza kartları', 'durum': 'devamEdiyor'},
          {'hedef': 'Sıralama becerisi', 'durum': 'baslanmadi'},
        ],
      },
      {
        'id': 8,
        'ad': 'Beden Eğitimi ve Oyun',
        'icon': Icons.sports_soccer_outlined,
        'renk': Colors.brown,
        'ilerleme': 80.0,
        'aciklama': 'Fiziksel gelişim',
        'sonGuncelleme': '11.12.2023',
        'hedefler': [
          {'hedef': 'Koşma durma', 'durum': 'tamamlandi'},
          {'hedef': 'Zıplama', 'durum': 'tamamlandi'},
          {'hedef': 'Denge hareketleri', 'durum': 'devamEdiyor'},
        ],
      },
    ];

    // Genel ilerleyiş istatistikleri
    final double genelIlerleme = akademikAlanlar
            .map<double>((alan) => (alan['ilerleme'] as double))
            .reduce((a, b) => a + b) /
        akademikAlanlar.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'İlerleyiş Takibi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            if (ogrenciAdi != null)
              Text(
                ogrenciAdi!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        backgroundColor: const Color(0xFF2196F3),
        centerTitle: false,
        automaticallyImplyLeading: false,
        elevation: 4,
        shadowColor: Colors.blue.withOpacity(0.3),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Genel İlerleyiş Kartı
              _buildGenelIlerleyisKarti(genelIlerleme),
              const SizedBox(height: 24),

              // Akademik Alanlar Başlığı
              const Text(
                'Akademik Alanlar İlerleyişi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Akademik Alanlar Listesi
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: akademikAlanlar.length,
                itemBuilder: (context, index) {
                  return _buildAkademikAlanKarti(
                      akademikAlanlar[index], context);
                },
              ),

              // Öğretmen Yorumu
              _buildOgretmenYorumuKarti(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenelIlerleyisKarti(double genelIlerleme) {
    return Container(
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
                  Icons.trending_up,
                  color: Color(0xFF2196F3),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Genel İlerleyiş Durumu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${genelIlerleme.toStringAsFixed(1)}% Tamamlandı',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // İlerleme Barı
          LinearProgressIndicator(
            value: genelIlerleme / 100,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Başlangıç',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              Text(
                '${genelIlerleme.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Hedef',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAkademikAlanKarti(
      Map<String, dynamic> alan, BuildContext context) {
    final Color renk = alan['renk'] as Color;
    final double ilerleme = alan['ilerleme'] as double;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showAlanDetayDialog(context, alan);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Alan İkonu
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: renk.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        alan['icon'] as IconData,
                        color: renk,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Alan Bilgileri
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alan['ad'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            alan['aciklama'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // İlerleme Yüzdesi
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getIlerlemeRengi(ilerleme).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '%${ilerleme.toInt()}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getIlerlemeRengi(ilerleme),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // İlerleme Barı
                LinearProgressIndicator(
                  value: ilerleme / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getIlerlemeRengi(ilerleme),
                  ),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 8),

                // Hedefler ve Güncelleme
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Son güncelleme: ${alan['sonGuncelleme']}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.remove_red_eye_outlined,
                            size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'Detay',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Icon(Icons.chevron_right,
                            size: 14, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOgretmenYorumuKarti() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_outline,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Öğretmen Yorumu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Öğrencimiz akademik alanlarda hızlı bir gelişim gösteriyor. Özellikle sosyal beceriler ve sanatsal aktivitelerdeki başarısı dikkat çekici. Öz bakım becerilerinde biraz daha desteğe ihtiyacı var. Destekleyici etkinliklerle bu alanı geliştireceğiz.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Sınıf Öğretmeni - 18.12.2023',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getIlerlemeRengi(double ilerleme) {
    if (ilerleme >= 80) return Colors.green;
    if (ilerleme >= 60) return Colors.blue;
    if (ilerleme >= 40) return Colors.orange;
    return Colors.red;
  }

  void _showAlanDetayDialog(
      BuildContext context, Map<String, dynamic> alan) {
    final Color renk = alan['renk'] as Color;
    final double ilerleme = alan['ilerleme'] as double;
    final List<dynamic> hedefler = alan['hedefler'] as List<dynamic>;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(alan['icon'] as IconData, color: renk),
            const SizedBox(width: 8),
            Text(
              alan['ad'] as String,
              style: TextStyle(
                color: renk,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alan['aciklama'] as String,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hedefler ve Durumları:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ...hedefler.map((hedef) {
                final Map<String, String> hedefMap =
                    hedef as Map<String, String>;
                final String durum = hedefMap['durum']!;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        _getHedefDurumIcon(durum),
                        size: 20,
                        color: _getHedefDurumRengi(durum),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(hedefMap['hedef']!)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getHedefDurumRengi(durum).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _getHedefDurumText(durum),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getHedefDurumRengi(durum),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: ilerleme / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getIlerlemeRengi(ilerleme),
                ),
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('İlerleme:'),
                  Text(
                    '%${ilerleme.toInt()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getIlerlemeRengi(ilerleme),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Son Güncelleme: ${alan['sonGuncelleme']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  IconData _getHedefDurumIcon(String durum) {
    switch (durum) {
      case 'tamamlandi':
        return Icons.check_circle;
      case 'devamEdiyor':
        return Icons.timelapse;
      default:
        return Icons.circle_outlined;
    }
  }

  Color _getHedefDurumRengi(String durum) {
    switch (durum) {
      case 'tamamlandi':
        return Colors.green;
      case 'devamEdiyor':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getHedefDurumText(String durum) {
    switch (durum) {
      case 'tamamlandi':
        return 'Tamamlandı';
      case 'devamEdiyor':
        return 'Devam Ediyor';
      default:
        return 'Başlanmadı';
    }
  }
}