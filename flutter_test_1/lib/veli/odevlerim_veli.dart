import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

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
      'ad': 'Destekleyici Eğitim Etkinlikleri',
      'icon': Icons.assistant_outlined,
      'renk': Colors.teal,
    },
    {
      'id': 2,
      'ad': 'Dil ve Konuşma Becerileri',
      'icon': Icons.record_voice_over,
      'renk': Colors.purple,
    },
    {
      'id': 3,
      'ad': 'Okuma ve Yazma Becerileri',
      'icon': Icons.edit,
      'renk': Colors.orange,
    },
    {
      'id': 4,
      'ad': 'Psikomotor Gelişim',
      'icon': Icons.directions_run,
      'renk': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Dosya açılamadı: $urlString')));
      }
    }
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
                // Tamamlanan Ödevler Tab - Şu an için boş veya aynı mantıkla filtrelenmiş olabilir
                // İsterseniz burayı da 'tamamlananOdevler' koleksiyonundan çekebilirsiniz.
                // Şimdilik sadece mesaj gösterelim veya bekleyenler mantığıyla ama tamamlandı flag'i ile (eğer olsa)
                // Ancak veritabanı yapısında 'bekleyenOdevler' ayrı bir koleksiyon gibi duruyor.
                _buildTamamlananList(),
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

  // Bekleyen ödevler için StreamBuilder
  Widget _buildOdevList({required bool isTamamlandi}) {
    // Sadece bekleyenler için çalışacak şekilde ayarladık,
    // "isTamamlandi" parametresi şu an kullanılmıyor çünkü koleksiyon farklı olabilir.
    // Ancak user "bekleyenOdevler" koleksiyonunu belirtti.

    if (widget.ogrenciAdi == null) {
      return const Center(child: Text("Öğrenci bilgisi bulunamadı."));
    }

    Query query = FirebaseFirestore.instance
        .collection('bekleyenOdevler')
        .where(
          Filter.or(
            Filter('ogrenci', isEqualTo: widget.ogrenciAdi),
            Filter('ogrenci', isEqualTo: 'Tüm Sınıf'),
          ),
        );

    if (_selectedDers != null) {
      query = query.where('ders', isEqualTo: _selectedDers);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                  "Bekleyen ödev bulunmamaktadır",
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

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            // Firestore document ID'sini de gönderelim
            return _buildOdevCard(data, doc.id, false);
          },
        );
      },
    );
  }

  // Tamamlananlar için placeholder widget
  Widget _buildTamamlananList() {
    if (widget.ogrenciAdi == null) {
      return const Center(child: Text("Öğrenci bilgisi bulunamadı."));
    }

    Query query = FirebaseFirestore.instance
        .collection('gonderilenOdevler')
        .where('ogrenci', isEqualTo: widget.ogrenciAdi);

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  "Tamamlanan ödev bulunmamaktadır",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final baslik = data['baslik'] ?? 'Başlıksız Ödev';
            final dosyaUrl = data['dosyaUrl'] as String?;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white),
                ),
                title: Text(
                  baslik,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: data['tamamlanmaTarihi'] != null
                    ? Text(
                        "Tamamlanma: ${data['tamamlanmaTarihi'] is Timestamp ? DateFormat('dd.MM.yyyy HH:mm').format((data['tamamlanmaTarihi'] as Timestamp).toDate()) : ''}",
                        style: const TextStyle(fontSize: 12),
                      )
                    : null,
                trailing: dosyaUrl != null && dosyaUrl.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.file_present,
                          color: Colors.blue,
                        ),
                        onPressed: () => _launchURL(dosyaUrl),
                        tooltip: 'Dosyayı Aç',
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  // isTamamlandi parametresi UI rengi veya buton kontrolü için
  Widget _buildOdevCard(
    Map<String, dynamic> odev,
    String docId,
    bool isTamamlandi,
  ) {
    // Ders rengini belirle
    Color getDersColor(String? ders) {
      if (ders == null) return Colors.grey;
      for (var alan in _akademikAlanlar) {
        if (alan['ad'] == ders) {
          return alan['renk'];
        }
      }
      return Colors.grey; // Varsayılan renk
    }

    final String ders = odev['ders'] ?? 'Genel';
    final color = getDersColor(ders);

    // Tarih formatlama
    String tarihText = '';
    if (odev['teslimTarihi'] != null) {
      // String olarak geliyorsa direkt, Timestamp geliyorsa formatla
      if (odev['teslimTarihi'] is Timestamp) {
        tarihText = DateFormat(
          'dd.MM.yyyy',
        ).format((odev['teslimTarihi'] as Timestamp).toDate());
      } else {
        tarihText = odev['teslimTarihi'].toString();
      }
    }

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
                  child: Icon(_getDersIcon(ders), color: color, size: 20),
                ),
                const SizedBox(width: 12),

                // Ders Adı
                Expanded(
                  child: Text(
                    ders,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),

                // Tarih
                if (tarihText.isNotEmpty)
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
                      tarihText,
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
                  odev['baslik'] ?? 'Başlıksız Ödev',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Açıklama
                if (odev['aciklama'] != null)
                  Text(
                    odev['aciklama'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),

                // Dosya Görüntüleme Butonu
                if (odev['dosyaUrl'] != null &&
                    (odev['dosyaUrl'] as String).isNotEmpty) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _launchURL(odev['dosyaUrl']),
                      icon: const Icon(Icons.file_present),
                      label: Text(odev['dosyaAdi'] ?? 'Dosyayı Görüntüle'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color,
                        side: BorderSide(color: color),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],

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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _odeviTamamlaDialog(odev, docId);
                  },
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  label: const Text("Ödevi Tamamla"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
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

  void _odeviTamamlaDialog(Map<String, dynamic> odev, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ödevi Tamamla"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              odev['baslik'] ?? 'Ödev',
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
            onPressed: () async {
              try {
                // Yükleniyor göstergesi veya buton disable yapılabilir ama şimdilik dialogu kapatıp işlem yapalım.
                Navigator.pop(context);

                // 1. 'gonderilenOdevler' ve 'bekleyenödevler' koleksiyonlarına ekle
                final data = {
                  ...odev,
                  'tamamlanmaTarihi': FieldValue.serverTimestamp(),
                  'ogrenciAdi': widget.ogrenciAdi,
                };

                await Future.wait([
                  FirebaseFirestore.instance
                      .collection('gonderilenOdevler')
                      .add(data),
                  FirebaseFirestore.instance.collection('notlar').add(data),
                  FirebaseFirestore.instance
                      .collection('hocanınNotlarEkranı')
                      .add(data),
                ]);

                // 2. 'bekleyenOdevler' koleksiyonundan sil
                await FirebaseFirestore.instance
                    .collection('bekleyenOdevler')
                    .doc(docId)
                    .delete();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "${odev['baslik']} ödevi tamamlandı ve gönderildi.",
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Bir hata oluştu: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
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
