import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OgretmenNotPage extends StatefulWidget {
  final String? teacherName;
  const OgretmenNotPage({super.key, this.teacherName});

  @override
  State<OgretmenNotPage> createState() => _OgretmenNotPageState();
}

class _OgretmenNotPageState extends State<OgretmenNotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Not Girişi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink, // Farklı bir renk teması
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('hocanınNotlarEkranı')
            .orderBy('tamamlanmaTarihi', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
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
                    Icons.assignment_turned_in,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Henüz gönderilen ödev yok.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              return _buildGradeCard(doc);
            },
          );
        },
      ),
    );
  }

  Widget _buildGradeCard(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final ogrenci =
        data['ogrenciAdi'] ??
        data['ogrenci'] ??
        'İsimsiz Öğrenci'; // ogrenciAdi veya ogrenci field'ına bak
    final ders = data['ders'] ?? 'Genel';
    final baslik = data['baslik'] ?? 'Başlıksız';
    final mevcutNot = data['not'] as String?;

    final TextEditingController notController = TextEditingController(
      text: mevcutNot,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.pink[100],
                  child: Text(
                    ogrenci.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Colors.pink[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ogrenci,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$ders - $baslik",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: notController,
                    decoration: InputDecoration(
                      hintText: 'Not veya yorum giriniz...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    if (notController.text.trim().isEmpty) return;

                    try {
                      // 1. 'notlar' collection'una ekle
                      await FirebaseFirestore.instance
                          .collection('notlar')
                          .add({
                            'baslik': baslik,
                            'ders': ders,
                            'not': notController.text.trim(),
                            'ogrenci': ogrenci,
                            'notTarihi': FieldValue.serverTimestamp(),
                          });

                      // 2. 'hocanınNotlarEkranı' collection'undan sil (şu anki döküman)
                      await doc.reference.delete();

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Not kaydedildi ve liste güncellendi",
                            ),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Hata: $e")));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Not Ver'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
