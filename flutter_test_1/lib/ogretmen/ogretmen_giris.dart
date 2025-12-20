import 'package:flutter/material.dart';
import 'gunun_anısı.dart';
import 'ev_odevleri.dart';
import 'ogretmen_plan.dart';
import 'ogrencilerim_list.dart';
import 'ogrenci_istatistik.dart';
import '../main.dart'; // For LoginPage navigation

class OgretmenGirisPage extends StatelessWidget {
  const OgretmenGirisPage({
    super.key,
    required this.ad,
    required this.email,
    required this.tip,
  });

  final String ad;
  final String email;
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hoş geldiniz, $ad Öğretmen',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profil Kartı
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFE3F2FD)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF1565C0,
                              ).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF1565C0),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFF1565C0),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ad,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Öğretmen',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueGrey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1565C0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'AKTİF',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(height: 1, color: Colors.grey[200]),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            color: Colors.blueGrey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              email,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.work_outline,
                            color: Colors.blueGrey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            tip,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Hızlı Erişim Başlığı
              // Hızlı Erişim başlığı ve şeridi
              // Padding(
              //   padding: const EdgeInsets.only(left: 8.0),
              //   child: Row(
              //     children: [
              //       Container(
              //         width: 4,
              //         height: 24,
              //         decoration: BoxDecoration(
              //           color: const Color(0xFF1565C0),
              //           borderRadius: BorderRadius.circular(2),
              //         ),
              //       ),
              //       const SizedBox(width: 12),
              //       const Text(
              //         'Hızlı Erişim',
              //         style: TextStyle(
              //           fontSize: 24,
              //           fontWeight: FontWeight.w700,
              //           color: Color(0xFF1A237E),
              //           letterSpacing: 0.5,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // const SizedBox(height: 8),
              //
              // Padding(
              //   padding: const EdgeInsets.only(left: 8.0),
              //   child: Text(
              //     'Öğretmen paneline hızlıca erişin',
              //     style: TextStyle(fontSize: 14, color: Colors.blueGrey[600]),
              //   ),
              // ),
              //
              // const SizedBox(height: 24),

              // Grid Menu
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.9,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  children: [
                    _buildMenuCard(
                      icon: Icons.star_rounded,
                      label: 'Günün Anısı',
                      color: Colors.amber[700]!,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD740), Color(0xFFFFC107)],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GununAnisi(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.assignment_rounded,
                      label: 'Ev Görevleri',
                      color: Colors.orange[700]!,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFB74D), Color(0xFFFF9800)],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EvOdevleriPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.calendar_month_rounded,
                      label: 'Planlayıcı',
                      color: Colors.teal[700]!,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4DB6AC), Color(0xFF009688)],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OgretmenPlanPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.people_rounded,
                      label: 'Öğrencilerim',
                      color: Colors.purple[700]!,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFBA68C8), Color(0xFF9C27B0)],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OgrencilerimPage(ad: ad),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.analytics_rounded,
                      label: 'İstatistikler',
                      color: Colors.blue[700]!,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OgrenciIstatistikPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.logout_rounded,
                      label: 'Çıkış Yap',
                      color: Colors.red[700]!,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEF5350), Color(0xFFD32F2F)],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Çıkış Yap'),
                            content: const Text(
                              'Uygulamadan çıkış yapmak istediğinize emin misiniz?',
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'İptal',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: const Text(
                                  'Çıkış Yap',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Alt Bilgi
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Son giriş: Bugün, 10:30',
                      style: TextStyle(
                        color: Colors.blueGrey[600],
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[100]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Çevrimiçi',
                            style: TextStyle(
                              color: Colors.green[800],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String label,
    required Color color,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: onTap,
              splashColor: color.withValues(alpha: 0.2),
              highlightColor: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[100]!, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: gradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(icon, size: 32, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A237E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 24,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
