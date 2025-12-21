import 'package:flutter/material.dart';

class OdevlerimVeli extends StatefulWidget {
  final String? ogrenciAdi;
  final String? sinif;

  const OdevlerimVeli({super.key, this.ogrenciAdi, this.sinif});

  @override
  State<OdevlerimVeli> createState() => _OdevlerimVeliState();
}

class _OdevlerimVeliState extends State<OdevlerimVeli>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedDers;

  final List<Map<String, dynamic>> _akademikAlanlar = [
    {
      'id': 1,
      'ad': 'Akademik Alanlar',
      'icon': Icons.school_outlined,
      'renk': Colors.blue,
    },
    {
      'id': 2,
      'ad': 'Dil ve İletişim Gelişimi',
      'icon': Icons.language_outlined,
      'renk': Colors.green,
    },
    {
      'id': 3,
      'ad': 'Sosyal ve Duygusal Gelişim',
      'icon': Icons.people_outline,
      'renk': Colors.orange,
    },
    {
      'id': 4,
      'ad': 'Öz Bakım ve Günlük Yaşam Becerileri',
      'icon': Icons.self_improvement_outlined,
      'renk': Colors.purple,
    },
    {
      'id': 5,
      'ad': 'Psikomotor Gelişim',
      'icon': Icons.directions_run_outlined,
      'renk': Colors.red,
    },
    {
      'id': 6,
      'ad': 'Sanat ve Estetik',
      'icon': Icons.brush_outlined,
      'renk': Colors.pink,
    },
    {
      'id': 7,
      'ad': 'Destekleyici Eğitim Etkinlikleri',
      'icon': Icons.assistant_outlined,
      'renk': Colors.teal,
    },
    {
      'id': 8,
      'ad': 'Beden Eğitimi ve Oyun',
      'icon': Icons.sports_soccer_outlined,
      'renk': Colors.brown,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDers = _akademikAlanlar[0]['ad'];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ödevlerim',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            if (widget.ogrenciAdi != null)
              Text(
                widget.ogrenciAdi!,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
          ],
        ),
        backgroundColor: const Color(0xFF2196F3),
        centerTitle: false,
        automaticallyImplyLeading: false,
        elevation: 4,
        shadowColor: Colors.blue.withOpacity(0.3),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          unselectedLabelColor: Colors.white70,
          labelColor: Colors.white,
          tabs: const [
            Tab(text: "Bekleyenler"),
            Tab(text: "Tamamlananlar"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Ders Filtreleme Alanı
          _buildDersFiltreleme(),

          // TabBarView Alanı
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Bekleyen Ödevler Tab
                _buildOdevList(isTamamlandi: false),
                // Tamamlanan Ödevler Tab
                _buildOdevList(isTamamlandi: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDersFiltreleme() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Akademik Alanlar',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _akademikAlanlar.length,
              itemBuilder: (context, index) {
                final alan = _akademikAlanlar[index];
                final isSelected = _selectedDers == alan['ad'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDers = selected ? alan['ad'] : null;
                      });
                    },
                    label: Text(alan['ad']),
                    avatar: Icon(
                      alan['icon'],
                      size: 18,
                      color: isSelected ? Colors.white : alan['renk'],
                    ),
                    backgroundColor: Colors.white,
                    selectedColor: alan['renk'],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: alan['renk'].withOpacity(0.3)),
                    ),
                    elevation: isSelected ? 2 : 0,
                    shadowColor: alan['renk'].withOpacity(0.2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOdevList({required bool isTamamlandi}) {
    // Filtrelenmiş ödev verileri
    final List<Map<String, dynamic>> odevler = _getFilteredOdevler(
      isTamamlandi,
    );

    if (odevler.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_turned_in_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              isTamamlandi
                  ? "Henüz tamamlanan ödev yok"
                  : "Bekleyen ödev bulunmamaktadır",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            if (_selectedDers != null) ...[
              const SizedBox(height: 8),
              Text(
                "Filtre: $_selectedDers",
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: odevler.length,
      itemBuilder: (context, index) {
        final odev = odevler[index];
        return _buildOdevCard(odev, isTamamlandi);
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredOdevler(bool isTamamlandi) {
    // Örnek ödev verileri - Gerçek uygulamada API'den gelecek
    final allOdevler = isTamamlandi
        ? [
            {
              'ders': 'Akademik Alanlar',
              'baslik': 'Rakamları Tanıma',
              'tarih': '18.12.2023',
              'not': 'Pekiyi',
              'aciklama': '1-10 arası rakamları tanıma ve yazma çalışması',
            },
            {
              'ders': 'Dil ve İletişim Gelişimi',
              'baslik': 'Sesli Okuma Çalışması',
              'tarih': '17.12.2023',
              'not': 'İyi',
              'aciklama': 'Basit cümleleri sesli okuma ve anlatma',
            },
            {
              'ders': 'Sosyal ve Duygusal Gelişim',
              'baslik': 'Duygu Kartları',
              'tarih': '16.12.2023',
              'not': 'Pekiyi',
              'aciklama': 'Farklı duygu ifadelerini tanıma ve ifade etme',
            },
          ]
        : [
            {
              'ders': 'Öz Bakım ve Günlük Yaşam Becerileri',
              'baslik': 'Düğme İlikleme',
              'tarih': '20.12.2023',
              'aciklama': 'Büyük düğmeleri ilikleme pratiği yapma',
            },
            {
              'ders': 'Psikomotor Gelişim',
              'baslik': 'Çizgi Çalışması',
              'tarih': '21.12.2023',
              'aciklama': 'Zig-zag çizgileri takip etme çalışması',
            },
            {
              'ders': 'Sanat ve Estetik',
              'baslik': 'Serbest Resim',
              'tarih': '20.12.2023',
              'aciklama': 'Sevdiği bir konuda resim yapma',
            },
            {
              'ders': 'Destekleyici Eğitim Etkinlikleri',
              'baslik': 'Hafıza Oyunu',
              'tarih': '19.12.2023',
              'aciklama': 'Eşleştirme kartları ile hafıza geliştirme',
            },
            {
              'ders': 'Beden Eğitimi ve Oyun',
              'baslik': 'Top Atma-Tutma',
              'tarih': '22.12.2023',
              'aciklama': 'Yumuşak top ile atma-tutma koordinasyon çalışması',
            },
          ];

    // Ders filtresi uygula
    if (_selectedDers != null) {
      return allOdevler.where((odev) => odev['ders'] == _selectedDers).toList();
    }

    return allOdevler;
  }

  Widget _buildOdevCard(Map<String, dynamic> odev, bool isTamamlandi) {
    // Ders rengini belirle
    Color getDersColor(String ders) {
      for (var alan in _akademikAlanlar) {
        if (alan['ad'] == ders) {
          return alan['renk'];
        }
      }
      return Colors.grey;
    }

    final color = getDersColor(odev['ders']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header Ribbon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(bottom: BorderSide(color: color.withOpacity(0.2))),
            ),
            child: Row(
              children: [
                // Ders İkonu
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Icon(
                    _getDersIcon(odev['ders']),
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Ders Adı
                Expanded(
                  child: Text(
                    odev['ders'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),

                // Tarih
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    odev['tarih'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // İçerik
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık
                Text(
                  odev['baslik'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Açıklama
                Text(
                  odev['aciklama'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),

                // Öğretmen Notu (sadece tamamlananlar için)
                if (isTamamlandi && odev.containsKey('not')) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[100]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Öğretmen Notu:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          odev['not'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Action Butonu (sadece bekleyenler için)
          if (!isTamamlandi)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Text(
                    "Ödev yapıldı mı?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Evet Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _odeviTamamlaDialog(odev);
                          },
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text("Evet"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Hayır Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Ödev henüz yapılmadı olarak işaretlendi.",
                                ),
                                backgroundColor: Colors.orange,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text("Hayır"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  IconData _getDersIcon(String ders) {
    for (var alan in _akademikAlanlar) {
      if (alan['ad'] == ders) {
        return alan['icon'];
      }
    }
    return Icons.menu_book_rounded;
  }

  void _odeviTamamlaDialog(Map<String, dynamic> odev) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ödevi Tamamla"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              odev['baslik'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Bu ödevi tamamladığınızı onaylıyor musunuz?",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${odev['baslik']} ödevi tamamlandı olarak işaretlendi",
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
            ),
            child: const Text("Tamamla", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
