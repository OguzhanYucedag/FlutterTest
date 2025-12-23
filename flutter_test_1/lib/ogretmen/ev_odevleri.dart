import 'dart:io';
import 'dart:math';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class EvOdevleriPage extends StatefulWidget {
  const EvOdevleriPage({super.key});

  @override
  State<EvOdevleriPage> createState() => _EvOdevleriPageState();
}

class _EvOdevleriPageState extends State<EvOdevleriPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController odevBaslik = TextEditingController();
  final TextEditingController odevDetaylari = TextEditingController();
  String? _selectedSubject;
  String? secilenOgrenci;
  DateTime? secilmisTarih;
  PlatformFile? secilenDosya;

  final List<String> dersbranslari = [
    'Akademik Alanlar',
    'Dil ve İletişim Gelişimi',
    'Sosyal ve Duygusal Gelişim',
    'Öz Bakım ve Günlük Yaşam Becerileri',
    'Psikomotor Gelişim',
    'Sanat ve Estetik',
    'Destekleyici Eğitim Etkinlikleri',
    'Beden Eğitimi ve Oyun',
  ];

  final List<String> ogrencilerList = [
    'Ahmet Yılmaz',
    'Ayşe Kaya',
    'Mehmet Demir',
    'Zeynep Çelik',
    'Can Yıldız',
  ];

  @override
  void dispose() {
    odevBaslik.dispose();
    odevDetaylari.dispose();
    super.dispose();
  }

  Future<void> secilecekTarih(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
              onSurface: Colors.blueGrey,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.orange),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != secilmisTarih) {
      setState(() {
        secilmisTarih = picked;
      });
    }
  }

  Future<void> secilecekDosya() async {
    FilePickerResult? result;
    
    try {
      if (kIsWeb) {
        // Web için withData: true kullan
        result = await FilePicker.platform.pickFiles(
          withData: true,
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx', 'ppt', 'pptx', 'txt'],
        );
      } else {
        // Mobil için normal pick
        result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx', 'ppt', 'pptx', 'txt'],
        );
      }
      
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          secilenDosya = result!.files.first;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dosya seçilirken hata: $e'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _submitHomework() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedSubject == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Lütfen bir ders seçiniz'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      if (secilmisTarih == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Lütfen teslim tarihi seçiniz'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final title = odevBaslik.text.trim();
      final description = odevDetaylari.text.trim();
      final subject = _selectedSubject;
      final student = secilenOgrenci;
      final dueDate = secilmisTarih!;

      String? downloadUrl;
      String? contentType;
      String? fileName;
      
      if (secilenDosya != null) {
        try {
          final uploadResult = await _uploadFile(secilenDosya!);
          downloadUrl = uploadResult.$1;
          contentType = uploadResult.$2;
          fileName = secilenDosya!.name;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dosya yüklenemedi: $e'),
              backgroundColor: Colors.red[400],
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
      }

      try {
        await FirebaseFirestore.instance.collection('bekleyenOdevler').add({
          'baslik': title,
          'aciklama': description,
          'ders': subject,
          'ogrenci': student ?? 'Tüm Sınıf',
          'teslimTarihi': Timestamp.fromDate(dueDate),
          'dosyaAdi': fileName ?? '',
          'dosyaUrl': downloadUrl ?? '',
          'dosyaTur': contentType ?? '',
          'olusturmaZamani': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Ödev başarıyla velilere gönderildi!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gönderilemedi: $e'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Reset form
      _formKey.currentState!.reset();
      odevBaslik.clear();
      odevDetaylari.clear();
      setState(() {
        _selectedSubject = null;
        secilenOgrenci = null;
        secilmisTarih = null;
        secilenDosya = null;
      });
    }
  }

  Future<(String, String)> _uploadFile(PlatformFile file) async {
    // 1️⃣ Dosya adı
    final String fileName = file.name;

    // 2️⃣ Dosya türünü belirle
    final String contentType = _inferContentType(fileName);

    // 3️⃣ Benzersiz dosya adı oluştur
    final String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_${fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_')}';
    final Reference ref = FirebaseStorage.instance.ref('odevler/$uniqueFileName');

    UploadTask uploadTask;

    // 4️⃣ PLATFORM KONTROLÜ - Web ve Mobil ayrımı
    if (kIsWeb) {
      // 🌐 FLUTTER WEB: bytes kullan
      if (file.bytes == null) {
        throw Exception('Web için dosya byte verisi alınamadı');
      }
      
      uploadTask = ref.putData(
        file.bytes!,
        SettableMetadata(contentType: contentType),
      );
    } else {
      // 📱 ANDROID / IOS: path kullan
      if (file.path == null) {
        throw Exception('Mobil için dosya yolu alınamadı');
      }
      
      // dart:io File sadece mobilde kullanılır
      final ioFile = File(file.path!);
      uploadTask = ref.putFile(
        ioFile,
        SettableMetadata(contentType: contentType),
      );
    }

    // 5️⃣ Yükleme tamamlanana kadar bekle
    final TaskSnapshot snapshot = await uploadTask;

    // 6️⃣ Download URL'sini al
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return (downloadUrl, contentType);
  }

  String _inferContentType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'gif':
        return 'image/gif';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'txt':
        return 'text/plain';
      case 'mp3':
        return 'audio/mpeg';
      case 'mp4':
        return 'video/mp4';
      default:
        return 'application/octet-stream';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFB74D),
                    Color(0xFFFF9800),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                title: const Text(
                  'Ödev Ekle',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: false,
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Subject Selection Card
                    _buildCard(
                      child: DropdownButtonFormField<String>(
                        value: _selectedSubject,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Gelişim Alanı / Ders Seçiniz',
                          prefixIcon: Icon(
                            Icons.category_rounded,
                            color: Colors.orange[700],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        items: dersbranslari.map((String subject) {
                          return DropdownMenuItem<String>(
                            value: subject,
                            child: Text(
                              subject,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSubject = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir ders seçiniz';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Student Selection Card
                    _buildCard(
                      child: DropdownButtonFormField<String>(
                        value: secilenOgrenci,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Öğrenci Seçiniz (Tüm Sınıf)',
                          prefixIcon: Icon(
                            Icons.person_rounded,
                            color: Colors.orange[700],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('Tüm Sınıf'),
                          ),
                          ...ogrencilerList.map((String student) {
                            return DropdownMenuItem<String>(
                              value: student,
                              child: Text(
                                student,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }),
                        ],
                        onChanged: (newValue) {
                          setState(() {
                            secilenOgrenci = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title Input
                    _buildCard(
                      child: TextFormField(
                        controller: odevBaslik,
                        decoration: InputDecoration(
                          labelText: 'Ödev Başlığı',
                          hintText: 'Örn: İnce motor becerileri çalışması',
                          prefixIcon: Icon(
                            Icons.title,
                            color: Colors.orange[700],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir başlık giriniz';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description Input
                    _buildCard(
                      child: TextFormField(
                        controller: odevDetaylari,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Açıklama',
                          hintText: 'Ödev detaylarını buraya yazınız...',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 60),
                            child: Icon(
                              Icons.description,
                              color: Colors.orange[700],
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen açıklama giriniz';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // File Upload Card
                    _buildCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_file_rounded,
                                  color: Colors.orange[700],
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Belge / Görsel Ekle',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (secilenDosya != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.orange.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.insert_drive_file,
                                      size: 20,
                                      color: Colors.orange[800],
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        secilenDosya!.name,
                                        style: TextStyle(
                                          color: Colors.orange[900],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          secilenDosya = null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )
                            else
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: secilecekDosya,
                                  icon: const Icon(Icons.upload_file),
                                  label: const Text('Dosya Seç'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.orange,
                                    side: const BorderSide(
                                      color: Colors.orange,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            if (secilenDosya != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Boyut: ${_formatFileSize(secilenDosya!.size)}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Date Picker
                    GestureDetector(
                      onTap: () => secilecekTarih(context),
                      child: _buildCard(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                color: Colors.orange[700],
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Teslim Tarihi',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    secilmisTarih == null
                                        ? 'Tarih Seçiniz'
                                        : '${secilmisTarih!.day}.${secilmisTarih!.month}.${secilmisTarih!.year}',
                                    style: TextStyle(
                                      color: secilmisTarih == null
                                          ? Colors.grey[400]
                                          : Colors.blueGrey[800],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitHomework,
                        icon: const Icon(Icons.send_rounded, color: Colors.white),
                        label: const Text(
                          'VELİYE GÖNDER',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.8,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF57C00),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                          shadowColor: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: child,
    );
  }
}