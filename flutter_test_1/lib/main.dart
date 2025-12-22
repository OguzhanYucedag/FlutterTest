import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'kayit.dart';
import 'kurum/anasayfakurum.dart';
import 'veli/anasayfaveli.dart';
import 'ogretmen/ogretmen_giris.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug bandı buradan kapatıldı
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // Use a custom gradient AppBar for a modern look
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(84),
        child: AppBar(
          centerTitle: true,
          elevation: 4,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4059F1), Color(0xFF73A1F9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.child_care, size: 28, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Hoşgeldiniz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ),
      // Make body scrollable to avoid overflow when keyboard appears and keep background image
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Background Image with transparency (kept from previous design)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/login_bg.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.85),
                    BlendMode.lighten,
                  ),
                ),
              ),
            ),

            // Main scrollable content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      // Headline centered
                      const Text(
                        'Kullanıcı Bilgilerinizi Giriniz',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B4380),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Enhanced container: accents behind + outer gradient stroke
                      SizedBox(
                        width: double.infinity,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            // accents behind the container
                            Positioned(
                              top: -32,
                              left: -28,
                              child: Container(
                                width: 88,
                                height: 88,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [Color(0xFFB59BFF), Colors.transparent],
                                    center: Alignment(-0.3, -0.3),
                                    radius: 0.9,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -32,
                              right: -32,
                              child: Container(
                                width: 96,
                                height: 96,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [Color(0xFF73A1F9), Colors.transparent],
                                    center: Alignment(0.6, 0.6),
                                    radius: 0.9,
                                  ),
                                ),
                              ),
                            ),

                            // outer gradient stroke container
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF9B7BFF), Color(0xFF73A1F9), Color(0xFFFF8A80)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(3), // thickness of gradient stroke
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(22.0),
                                  child: Column(
                                    children: [
                                      // Email (prominent)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(14),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.06),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: TextFormField(
                                          controller: _emailController,
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                                            prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF6C5CE7)),
                                            hintText: 'Email',
                                            hintStyle: TextStyle(color: Colors.grey.shade600),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(14),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(14),
                                              borderSide: BorderSide(color: Colors.deepPurple.shade200, width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),

                                      // Password (prominent)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(14),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.06),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: TextFormField(
                                          controller: _passwordController,
                                          obscureText: _obscurePassword,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                                            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6C5CE7)),
                                            hintText: 'Şifre',
                                            hintStyle: TextStyle(color: Colors.grey.shade600),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(14),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(14),
                                              borderSide: BorderSide(color: Colors.deepPurple.shade200, width: 2),
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade600),
                                              onPressed: () {
                                                setState(() {
                                                  _obscurePassword = !_obscurePassword;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      // Buttons
                                      Column(
                                        children: [
                                          // Gradient primary button
                                          SizedBox(
                                            width: double.infinity,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [Color(0xFF6C5CE7), Color(0xFF4059F1)],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.12),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: ElevatedButton(
                                                onPressed: _girisYap,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.transparent,
                                                  shadowColor: Colors.transparent,
                                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                ),
                                                child: const Text(
                                                  'Giriş Yap',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),

                                          // Outlined secondary button
                                          SizedBox(
                                            width: double.infinity,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const KayitPage()),
                                                );
                                              },
                                              style: OutlinedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                side: BorderSide(color: Colors.purple.shade200),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              ),
                                              child: Text(
                                                'Kayıt Ol',
                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.purple.shade700),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),
                      // Extra spacer for comfortable bottom padding
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ),

            
          ],
        ),
      ),
    );
  }

  
  //giriş yapma kısmı 
  Future<void> _girisYap() async {
    final email = _emailController.text.trim();
    final sifre = _passwordController.text.trim();

    if (email.isEmpty || sifre.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email ve şifre giriniz')));
      return;
    }

    // Önce genel kurumlar koleksiyonunda arar
    final sorguKurumlar = await FirebaseFirestore.instance
        .collection('kurumlar')
        .where('kullanıcıEmail', isEqualTo: email)
        .where('kullanıcıŞifre', isEqualTo: sifre)
        .limit(1)
        .get();

    // Ardından veliler koleksiyonunda ayrı bir kontrol yapılır
    final sorguVeliler = sorguKurumlar.docs.isNotEmpty
        ? null
        : await FirebaseFirestore.instance
            .collection('veliler')
            .where('kullanıcıEmail', isEqualTo: email)
            .where('kullanıcıŞifre', isEqualTo: sifre)
            .limit(1)
            .get();
    
    final sorguOgretmenler = sorguKurumlar.docs.isNotEmpty
        ? null
        : await FirebaseFirestore.instance
            .collection('ogretmenler')
            .where('kullanıcıEmail', isEqualTo: email)
            .where('kullanıcıŞifre', isEqualTo: sifre)
            .limit(1)
            .get();

    final veri = sorguKurumlar.docs.isNotEmpty
        ? sorguKurumlar.docs.first.data()
        : (sorguVeliler?.docs.isNotEmpty ?? false)
            ? sorguVeliler!.docs.first.data()
            : (sorguOgretmenler?.docs.isNotEmpty ?? false)
                ? sorguOgretmenler!.docs.first.data()
                : null;

    if (veri != null) {
      final String ad = veri['kullanıcıAd'] ?? '';
      final String tip = veri['tip'] ?? '';

      if (!mounted) return;
      //Giriş yapan Kurum Yada Veli mi diye kontrol eder
      if (tip == "kurum") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AnasayfaPageKurum(ad: ad, email: email, tip: tip),
          ),
        );
      }
      if (tip == "veli") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AnasayfaPageVeli(ad: ad, email: email, tip: tip),
          ),
        );
      }
      if (tip == "ogretmen") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OgretmenGirisPage(ad: ad, email: email, tip: tip),
          ),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email veya şifre hatalı')));
    }
  }
}