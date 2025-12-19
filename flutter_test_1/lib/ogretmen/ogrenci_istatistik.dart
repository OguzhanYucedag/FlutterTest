import 'package:flutter/material.dart';

class OgrenciIstatistikPage extends StatefulWidget {
  final String? ogretmenAdi;

  const OgrenciIstatistikPage({super.key, this.ogretmenAdi});

  @override
  State<OgrenciIstatistikPage> createState() => _OgrenciIstatistikPageState();
}

class _OgrenciIstatistikPageState extends State<OgrenciIstatistikPage> {
  // Görseldeki akademik alanlar
  final List<String> _academicFields = [
    'Akademik Alanlar',
    'Dil ve İletişim Gelişimi',
    'Sosyal ve Duygusal Gelişim',
    'Öz Bakım ve Günlük Yaşam Becerileri',
    'Psikomotor Gelişim',
    'Sanat ve Estetik',
    'Destekleyici Eğitim Etkinlikleri',
    'Beden Eğitimi ve Oyun',
  ];

  // Renk paleti
  final Map<String, Color> _fieldColors = {
    'Akademik Alanlar': const Color(0xFF4A6FA5),
    'Dil ve İletişim Gelişimi': const Color(0xFFE63946),
    'Sosyal ve Duygusal Gelişim': const Color(0xFF2A9D8F),
    'Öz Bakım ve Günlük Yaşam Becerileri': const Color(0xFFE9C46A),
    'Psikomotor Gelişim': const Color(0xFFF4A261),
    'Sanat ve Estetik': const Color(0xFF9B5DE5),
    'Destekleyici Eğitim Etkinlikleri': const Color(0xFF00BBF9),
    'Beden Eğitimi ve Oyun': const Color(0xFF06D6A0),
  };

  // Iconlar
  final Map<String, IconData> _fieldIcons = {
    'Akademik Alanlar': Icons.school,
    'Dil ve İletişim Gelişimi': Icons.language,
    'Sosyal ve Duygusal Gelişim': Icons.psychology,
    'Öz Bakım ve Günlük Yaşam Becerileri': Icons.self_improvement,
    'Psikomotor Gelişim': Icons.directions_run,
    'Sanat ve Estetik': Icons.palette,
    'Destekleyici Eğitim Etkinlikleri': Icons.science,
    'Beden Eğitimi ve Oyun': Icons.sports_soccer,
  };

  // Dummy Data - Öğrenciler
  final List<Map<String, dynamic>> _studentStats = [
    {
      'name': 'Ahmet Yılmaz',
      'avatarColor': Colors.blue,
      'teacherComment':
          'Ahmet matematik alanında çok başarılı, ancak sosyal becerilerde biraz desteğe ihtiyacı var.',
      'subjects': [
        {'name': 'Akademik Alanlar', 'progress': 0.85},
        {'name': 'Dil ve İletişim Gelişimi', 'progress': 0.70},
        {'name': 'Sosyal ve Duygusal Gelişim', 'progress': 0.90},
        {'name': 'Öz Bakım ve Günlük Yaşam Becerileri', 'progress': 0.78},
        {'name': 'Psikomotor Gelişim', 'progress': 0.82},
      ],
    },
    {
      'name': 'Ayşe Kaya',
      'avatarColor': Colors.purple,
      'teacherComment':
          'Ayşe sanat ve estetik alanında çok yetenekli, yaratıcılığı takdire şayan.',
      'subjects': [
        {'name': 'Akademik Alanlar', 'progress': 0.95},
        {'name': 'Dil ve İletişim Gelişimi', 'progress': 0.88},
        {'name': 'Sosyal ve Duygusal Gelişim', 'progress': 0.92},
        {'name': 'Sanat ve Estetik', 'progress': 0.96},
        {'name': 'Destekleyici Eğitim Etkinlikleri', 'progress': 0.89},
      ],
    },
    {
      'name': 'Can Yıldız',
      'avatarColor': Colors.teal,
      'teacherComment':
          'Can beden eğitiminde çok başarılı, ancak akademik alanlarda desteğe ihtiyacı var.',
      'subjects': [
        {'name': 'Akademik Alanlar', 'progress': 0.65},
        {'name': 'Beden Eğitimi ve Oyun', 'progress': 0.95},
        {'name': 'Psikomotor Gelişim', 'progress': 0.92},
        {'name': 'Sosyal ve Duygusal Gelişim', 'progress': 0.75},
        {'name': 'Öz Bakım ve Günlük Yaşam Becerileri', 'progress': 0.70},
      ],
    },
    {
      'name': 'Zeynep Çelik',
      'avatarColor': Colors.orange,
      'teacherComment':
          'Zeynep dil becerilerinde çok iyi, iletişim kurma konusunda örnek bir öğrenci.',
      'subjects': [
        {'name': 'Dil ve İletişim Gelişimi', 'progress': 0.92},
        {'name': 'Sanat ve Estetik', 'progress': 0.88},
        {'name': 'Akademik Alanlar', 'progress': 0.78},
        {'name': 'Destekleyici Eğitim Etkinlikleri', 'progress': 0.85},
        {'name': 'Sosyal ve Duygusal Gelişim', 'progress': 0.91},
      ],
    },
    {
      'name': 'Mehmet Demir',
      'avatarColor': Colors.green,
      'teacherComment':
          'Mehmet fiziksel aktivitelerde çok başarılı, ancak dil becerilerini geliştirmeye ihtiyacı var.',
      'subjects': [
        {'name': 'Beden Eğitimi ve Oyun', 'progress': 0.85},
        {'name': 'Psikomotor Gelişim', 'progress': 0.80},
        {'name': 'Akademik Alanlar', 'progress': 0.55},
        {'name': 'Dil ve İletişim Gelişimi', 'progress': 0.60},
        {'name': 'Öz Bakım ve Günlük Yaşam Becerileri', 'progress': 0.75},
      ],
    },
  ];

  // Sınıf ortalaması hesapla
  Map<String, double> _calculateClassAverages() {
    final Map<String, List<double>> progressMap = {};

    for (var student in _studentStats) {
      for (var subject in student['subjects']) {
        final subjectName = subject['name'];
        final progress = subject['progress'];

        progressMap.putIfAbsent(subjectName, () => []);
        progressMap[subjectName]!.add(progress);
      }
    }

    final averages = <String, double>{};
    progressMap.forEach((subject, values) {
      final average = values.reduce((a, b) => a + b) / values.length;
      averages[subject] = double.parse(average.toStringAsFixed(2));
    });

    return averages;
  }

  // Yorum düzenleme için state
  int? _selectedStudentIndex;
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showEditCommentDialog(int index, String currentComment) {
    _selectedStudentIndex = index;
    _commentController.text = currentComment;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.comment, color: Color(0xFF1E88E5)),
            const SizedBox(width: 8),
            Text(
              '${_studentStats[index]['name']} - Yorum Düzenle',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _commentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Öğrenci için yorumunuzu yazın...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bu yorum veli ekranında görünecektir.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_commentController.text.isNotEmpty) {
                setState(() {
                  _studentStats[index]['teacherComment'] =
                      _commentController.text;
                });
                Navigator.pop(context);

                // Başarı mesajı göster
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${_studentStats[index]['name']} için yorum güncellendi',
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5),
            ),
            child: const Text('Kaydet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final classAverages = _calculateClassAverages();

    // En başarılı 3 alanı sırala
    final topSubjects = classAverages.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topThreeSubjects = topSubjects.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // AppBar
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
                    colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Öğrenci İstatistikleri',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  if (widget.ogretmenAdi != null)
                    Text(
                      widget.ogretmenAdi!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                ],
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

          // İçerik
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index == 0) {
                  return _buildClassSummary(topThreeSubjects);
                }
                final studentIndex = index - 1;
                final student = _studentStats[studentIndex];
                return _buildStudentStatCard(student, studentIndex);
              }, childCount: _studentStats.length + 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassSummary(List<MapEntry<String, double>> topSubjects) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Başlık
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E88E5).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E88E5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.analytics_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sınıf Performans Raporu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                        ),
                      ),
                      Text(
                        '${_studentStats.length} öğrenci • ${_academicFields.length} alan',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.trending_up_rounded,
                  color: Colors.green[400],
                  size: 30,
                ),
              ],
            ),
          ),

          // İstatistikler
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'En Başarılı Alanlar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF455A64),
                      ),
                    ),
                    Text(
                      'Ortalama',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...topSubjects.asMap().entries.map((entry) {
                  final subject = entry.value;
                  final color = _fieldColors[subject.key] ?? Colors.grey;
                  final icon = _fieldIcons[subject.key] ?? Icons.category;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            subject.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '%${(subject.value * 100).toInt()}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentStatCard(Map<String, dynamic> student, int studentIndex) {
    final List<Map<String, dynamic>> subjects = List<Map<String, dynamic>>.from(
      student['subjects'],
    );

    // İlerleme ortalaması hesapla
    final double averageProgress =
        subjects.map((s) => s['progress'] as double).reduce((a, b) => a + b) /
        subjects.length;

    final String teacherComment = student['teacherComment'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  student['avatarColor'] as Color,
                  (student['avatarColor'] as Color).withOpacity(0.7),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (student['avatarColor'] as Color).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                (student['name'] as String).substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          title: Text(
            student['name'] as String,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF263238),
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                'Genel Ortalama: %${(averageProgress * 100).toInt()}',
                style: TextStyle(
                  fontSize: 12,
                  color: _getPerformanceColor(averageProgress),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _getPerformanceIcon(averageProgress),
                size: 14,
                color: _getPerformanceColor(averageProgress),
              ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.expand_more_rounded,
              color: Colors.blue[600],
              size: 20,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            // Öğretmen Yorumu Bölümü
            Container(
              margin: const EdgeInsets.only(bottom: 16),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.comment,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Öğretmen Yorumu',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          _showEditCommentDialog(studentIndex, teacherComment);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    teacherComment.isNotEmpty
                        ? teacherComment
                        : 'Henüz yorum eklenmemiş.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  if (widget.ogretmenAdi != null && teacherComment.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          widget.ogretmenAdi!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Ders İlerlemeleri
            const Divider(color: Colors.grey, height: 20),
            const SizedBox(height: 8),
            const Text(
              'Ders İlerlemeleri',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF455A64),
              ),
            ),
            const SizedBox(height: 12),
            ...subjects.map((subject) {
              final color = _fieldColors[subject['name']] ?? Colors.grey;
              final icon = _fieldIcons[subject['name']] ?? Icons.category;

              return _buildSubjectProgressItem(subject, color, icon);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectProgressItem(
    Map<String, dynamic> subject,
    Color color,
    IconData icon,
  ) {
    final progress = subject['progress'] as double;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        subject['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF455A64),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '%${(progress * 100).toInt()}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor(double progress) {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.6) return Colors.orange;
    return Colors.red;
  }

  IconData _getPerformanceIcon(double progress) {
    if (progress >= 0.8) return Icons.trending_up_rounded;
    if (progress >= 0.6) return Icons.trending_flat_rounded;
    return Icons.trending_down_rounded;
  }
}
