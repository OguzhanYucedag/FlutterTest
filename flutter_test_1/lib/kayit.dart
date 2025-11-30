import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KayitPage extends StatefulWidget {
  const KayitPage({super.key});

  @override
  State<KayitPage> createState() => _KayitPageState();
}

class _KayitPageState extends State<KayitPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _selectedOption = 0; // 0 for first button, 1 for second button

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    // Validate fields
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('Lütfen ${_selectedOption == 0 ? "Kurum Adı" : "Ad Soyad"} giriniz');
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar('Lütfen Email giriniz');
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showErrorSnackBar('Lütfen Şifre giriniz');
      return;
    }

    if (_confirmPasswordController.text.isEmpty) {
      _showErrorSnackBar('Lütfen Şifre Tekrar giriniz');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Şifreler eşleşmiyor');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showErrorSnackBar('Şifre en az 6 karakter olmalıdır');
      return;
    }

    try {
      final String nameToCheck = _nameController.text.trim();
      
      // Check if name/kurum adı already exists in Firestore
      try {
        final QuerySnapshot existingUsers = await FirebaseFirestore.instance
            .collection('Test')
            .where('name', isEqualTo: nameToCheck)
            .get();

        if (existingUsers.docs.isNotEmpty) {
          final String fieldName = _selectedOption == 0 ? 'Kurum Adı' : 'Ad Soyad';
          _showErrorSnackBar('Bu $fieldName zaten kullanılıyor');
          return;
        }
      } catch (e) {
        // Firestore query error - continue with registration if query fails
        // This handles cases where index is not created yet
        print('Firestore query error: $e');
      }

      // Create user with Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Update user display name
      await userCredential.user?.updateDisplayName(nameToCheck);

      // Save user data to Firestore in 'Test' collection
      if (userCredential.user?.uid != null) {
        try {
          await FirebaseFirestore.instance.collection('Test').doc(userCredential.user!.uid).set({
            'name': nameToCheck,
            'email': _emailController.text.trim(),
            'userType': _selectedOption == 0 ? 'kurum' : 'veli',
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: false));
          print('Firestore\'a başarıyla kaydedildi');
        } catch (e) {
          // Firestore write error - show error to user
          print('Firestore write error: $e');
          _showErrorSnackBar('Firestore\'a kayıt yapılamadı: ${e.toString()}');
          // Delete the created user from Auth since Firestore write failed
          try {
            await userCredential.user?.delete();
          } catch (deleteError) {
            print('User deletion error: $deleteError');
          }
          return;
        }
      } else {
        _showErrorSnackBar('Kullanıcı ID alınamadı');
        return;
      }

      // Show success message
      _showSuccessSnackBar('Kayıt başarıyla oluşturuldu!');

      // Clear fields
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      // Navigate back after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Kayıt işlemi başarısız oldu';
      if (e.code == 'weak-password') {
        errorMessage = 'Şifre çok zayıf';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Bu email adresi zaten kullanılıyor';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Geçersiz email adresi';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'İnternet bağlantısı hatası. Lütfen kontrol edin.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Email/Şifre ile kayıt etkin değil. Firebase yapılandırmasını kontrol edin.';
      } else {
        errorMessage = 'Hata: ${e.code} - ${e.message ?? "Bilinmeyen hata"}';
      }
      _showErrorSnackBar(errorMessage);
    } catch (e) {
      String errorMessage = 'Bir hata oluştu';
      if (e.toString().contains('YOUR_') || e.toString().contains('API_KEY')) {
        errorMessage = 'Firebase yapılandırması eksik! Lütfen "flutterfire configure" komutunu çalıştırın.';
      } else if (e.toString().contains('index') || e.toString().contains('Index')) {
        errorMessage = 'Firestore index hatası. Firebase Console\'da index oluşturmanız gerekebilir.';
      } else if (e.toString().contains('permission') || e.toString().contains('Permission')) {
        errorMessage = 'Firestore izin hatası. Security rules\'u kontrol edin.';
      } else {
        errorMessage = 'Hata: ${e.toString()}';
      }
      _showErrorSnackBar(errorMessage);
      print('Registration error: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[300], // Açık yeşil
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[300],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title section
              const Text(
                'Hesap Bilgilerinizi Giriniz',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              
              
              // Name field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: _selectedOption == 0 ? 'Kurum Adı' : 'Ad Soyad',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Email field
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),
              
              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Confirm Password field
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Şifre Tekrar',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              const Spacer(),
              
              // Two selection buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // First button
                  Expanded(
                    child: Material(
                      color: _selectedOption == 0 ? const Color.fromARGB(255, 96, 96, 96) : Colors.transparent,
                      borderRadius: BorderRadius.circular(32),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedOption = 0;
                          });
                        },
                        borderRadius: BorderRadius.circular(32),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Kurum Kaydı',
                            style: TextStyle(
                              color: _selectedOption == 0 ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Second button
                  Expanded(
                    child: Material(
                      color: _selectedOption == 1 ? const Color.fromARGB(255, 96, 96, 96) : Colors.transparent,
                      borderRadius: BorderRadius.circular(32),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedOption = 1;
                          });
                        },
                        borderRadius: BorderRadius.circular(32),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Veli Kaydı',
                            style: TextStyle(
                              color: _selectedOption == 1 ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Kayıt Ol button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await _handleRegistration();
                    },
                    borderRadius: BorderRadius.circular(32),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      alignment: Alignment.center,
                      child: const Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

