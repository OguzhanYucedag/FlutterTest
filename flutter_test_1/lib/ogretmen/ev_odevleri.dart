import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class EvOdevleriPage extends StatefulWidget {
  const EvOdevleriPage({super.key});

  @override
  State<EvOdevleriPage> createState() => _EvOdevleriPageState();
}

class _EvOdevleriPageState extends State<EvOdevleriPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedSubject;
  String? _selectedStudent;
  DateTime? _selectedDate;
  PlatformFile? _selectedFile;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  final List<String> _subjects = [
    'Akademik Alanlar',
    'Dil ve İletişim Gelişimi',
    'Sosyal ve Duygusal Gelişim',
    'Öz Bakım ve Günlük Yaşam Becerileri',
    'Psikomotor Gelişim',
    'Sanat ve Estetik',
    'Destekleyici Eğitim Etkinlikleri',
    'Beden Eğitimi ve Oyun',
  ];

  final List<String> _students = [
    'Ahmet Yılmaz',
    'Ayşe Kaya',
    'Mehmet Demir',
    'Zeynep Çelik',
    'Can Yıldız',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'png',
        'jpg',
        'jpeg',
        'doc',
        'docx',
        'ppt',
        'pptx',
        'txt',
        'zip'
      ],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _submitHomework() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lütfen teslim tarihi seçiniz'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final subject = _selectedSubject;
    final student = _selectedStudent;
    final dueDate = _selectedDate!;

    String? downloadUrl;
    String? contentType;
    String? fileName;

    // Dosya yükleme işlemi
    if (_selectedFile != null && _selectedFile!.path != null) {
      try {
        final result = await _uploadFile(_selectedFile!);
        downloadUrl = result['url'];
        contentType = result['contentType'];
        fileName = result['fileName'];
      } catch (e) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dosya yüklenemedi: ${e.toString()}'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
        return;
      }
    }

    // Firestore'a veri ekleme
    try {
      final homeworkData = <String, dynamic>{
        'baslik': title,
        'aciklama': description,
        'ders': subject,
        'ogrenci': student ?? 'Tüm Sınıf',
        'teslimTarihi': Timestamp.fromDate(dueDate),
        'dosyaAdi': fileName ?? _selectedFile?.name ?? '',
        'dosyaUrl': downloadUrl ?? '',
        'dosyaTur': contentType ?? '',
        'olusturmaZamani': FieldValue.serverTimestamp(),
        'durum': 'beklemede',
      };

      await FirebaseFirestore.instance
          .collection('bekleyenOdevler')
          .add(homeworkData);

      // Başarılı mesajı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
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
          duration: const Duration(seconds: 3),
        ),
      );

      // Formu temizle
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gönderilemedi: $e'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  Future<Map<String, String>> _uploadFile(PlatformFile file) async {
    try {
      final filePath = file.path!;
      final originalFileName = file.name;
      
      // Dosya adını güvenli hale getir
      final safeFileName = _createSafeFileName(originalFileName);
      final contentType = _inferContentType(originalFileName);
      
      // Firebase Storage referansı oluştur
      final ref = FirebaseStorage.instance
          .ref()
          .child('odevler')
          .child(safeFileName);

      // Dosyayı yükle
      final uploadTask = ref.putFile(
        File(filePath),
        SettableMetadata(contentType: contentType),
      );

      // Yükleme ilerlemesini dinle
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        setState(() {
          _uploadProgress = progress;
        });
      });

      // Yükleme tamamlanmasını bekle ve snapshot üzerinden URL al
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

      if (snapshot.state != TaskState.success) {
        throw Exception('Dosya yükleme başarısız: ${snapshot.state}');
      }

      // İndirme URL'sini, tamamlanan snapshot üzerinden al
      final url = await snapshot.ref.getDownloadURL();

      return {
        'url': url,
        'contentType': contentType,
        'fileName': safeFileName,
      };
    } catch (e) {
      print('Dosya yükleme hatası: $e');
      throw Exception('Dosya yükleme hatası: $e');
    }
  }

  String _createSafeFileName(String originalName) {
    // Zaman damgası ekleyerek benzersiz isim oluştur
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = path.extension(originalName);
    final nameWithoutExtension = path.basenameWithoutExtension(originalName);
    
    // Özel karakterleri kaldır ve boşlukları alt çizgi ile değiştir
    final safeName = nameWithoutExtension
        .replaceAll(RegExp(r'[^a-zA-Z0-9öçşığüÖÇŞİĞÜ\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_');
    
    return '${safeName}_$timestamp$extension';
  }

  String _inferContentType(String fileName) {
    final ext = path.extension(fileName).toLowerCase();
    switch (ext) {
      case '.pdf':
        return 'application/pdf';
      case '.png':
        return 'image/png';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.ppt':
        return 'application/vnd.ms-powerpoint';
      case '.pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case '.txt':
        return 'text/plain';
      case '.zip':
        return 'application/zip';
      case '.mp4':
        return 'video/mp4';
      case '.mp3':
        return 'audio/mpeg';
      default:
        return 'application/octet-stream';
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedSubject = null;
      _selectedStudent = null;
      _selectedDate = null;
      _selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          CustomScrollView(
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
                        Color(0xFFFFB74D), // Orange 300
                        Color(0xFFFF9800), // Orange 500
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
                  onPressed: _isUploading ? null : () => Navigator.pop(context),
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
                            items: _subjects.map((String subject) {
                              return DropdownMenuItem<String>(
                                value: subject,
                                child: Text(
                                  subject,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: _isUploading
                                ? null
                                : (newValue) {
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
                            value: _selectedStudent,
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
                              ..._students.map((String student) {
                                return DropdownMenuItem<String>(
                                  value: student,
                                  child: Text(
                                    student,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                            ],
                            onChanged: _isUploading
                                ? null
                                : (newValue) {
                                    setState(() {
                                      _selectedStudent = newValue;
                                    });
                                  },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title Input
                        _buildCard(
                          child: TextFormField(
                            controller: _titleController,
                            enabled: !_isUploading,
                            decoration: InputDecoration(
                              labelText: 'Ödev Başlığı',
                              hintText: 'Örn: İnce motor bec çalışması',
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
                              if (value.length < 3) {
                                return 'Başlık en az 3 karakter olmalıdır';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description Input
                        _buildCard(
                          child: TextFormField(
                            controller: _descriptionController,
                            enabled: !_isUploading,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: 'Açıklama',
                              hintText: 'Ödev detaylarını buraya yazınız...',
                              alignLabelWithHint: true,
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
                              if (value.length < 10) {
                                return 'Açıklama en az 10 karakter olmalıdır';
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
                                if (_selectedFile != null)
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
                                          _getFileIcon(_selectedFile!.name),
                                          size: 20,
                                          color: Colors.orange[800],
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _selectedFile!.name,
                                                style: TextStyle(
                                                  color: Colors.orange[900],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                '${(_selectedFile!.size / 1024).toStringAsFixed(2)} KB',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (!_isUploading)
                                          IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              size: 18,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _selectedFile = null;
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
                                      onPressed: _isUploading ? null : _pickFile,
                                      icon: const Icon(Icons.upload_file),
                                      label: const Text('Dosya Seç'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.orange,
                                        side: const BorderSide(
                                          color: Colors.orange,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_selectedFile != null && !_isUploading)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Not: Dosya başarıyla seçildi. Gönder butonuna basarak yükleyebilirsiniz.',
                                      style: TextStyle(
                                        color: Colors.green[700],
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
                          onTap: _isUploading
                              ? null
                              : () => _selectDate(context),
                          child: Opacity(
                            opacity: _isUploading ? 0.5 : 1.0,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          _selectedDate == null
                                              ? 'Tarih Seçiniz'
                                              : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
                                          style: TextStyle(
                                            color: _selectedDate == null
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
                        ),
                        
                        // Yükleme İlerleme Göstergesi
                        if (_isUploading && _uploadProgress > 0)
                          Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildCard(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.cloud_upload,
                                            color: Colors.orange[700],
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            'Dosya Yükleniyor',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      LinearProgressIndicator(
                                        value: _uploadProgress,
                                        backgroundColor: Colors.grey[200],
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.orange,
                                        ),
                                        minHeight: 8,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${(_uploadProgress * 100).toStringAsFixed(1)}%',
                                          style: TextStyle(
                                            color: Colors.orange[700],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        
                        const SizedBox(height: 32),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isUploading ? null : _submitHomework,
                            icon: const Icon(Icons.send_rounded,
                                color: Colors.white),
                            label: Text(
                              _isUploading ? 'GÖNDERİLİYOR...' : 'VELİYE GÖNDER',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isUploading
                                  ? Colors.grey
                                  : const Color(0xFFF57C00),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 4,
                              shadowColor: Colors.orange.withOpacity(0.3),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Info Text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Not: Ödevler velilere otomatik olarak gönderilecek ve "Bekleyen Ödevler" listesinde görünecektir.',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isUploading && _uploadProgress == 0)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  strokeWidth: 3,
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

  IconData _getFileIcon(String fileName) {
    final ext = path.extension(fileName).toLowerCase();
    switch (ext) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.png':
      case '.jpg':
      case '.jpeg':
        return Icons.image;
      case '.doc':
      case '.docx':
        return Icons.description;
      case '.ppt':
      case '.pptx':
        return Icons.slideshow;
      case '.txt':
        return Icons.text_fields;
      case '.zip':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }
}