import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmtok/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _signup() async {
    String adSoyad = _nameController.text.trim();
    String email = _emailController.text.trim();
    String sifre = _passwordController.text.trim();
    String sifreTekrari = _confirmPasswordController.text.trim();

    // Ad Soyad Kontrolü: En az iki kelime
    if (adSoyad.split(" ").length < 2) {
      _showError("Lütfen adınızı ve soyadınızı eksiksiz giriniz.");
      return;
    }

    // Geçerli E-posta Kontrolü
    if (!_isValidEmail(email)) {
      _showError(
        "Lütfen geçerli bir e-posta adresi giriniz (ör. mail@gmail.com).",
      );
      return;
    }

    // Şifre Güçlülük Kontrolü
    if (!_isValidPassword(sifre)) {
      _showError(
        "Şifre en az 8 karakter, harf, rakam ve özel karakter içermelidir.",
      );
      return;
    }

    // Şifre Eşleşme Kontrolü
    if (sifre != sifreTekrari) {
      _showError("Şifreler uyuşmuyor!");
      return;
    }

    try {
      // Kullanıcı e-posta ile zaten kayıtlı mı kontrol et
      var methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        _showError("Bu e-posta adresi zaten kullanılıyor!");
        return;
      }

      // Firebase Authentication ile kullanıcı oluştur
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: sifre);

      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "id": user.uid,
          "fullName": adSoyad,
          "email": email,
          "profileUrl": "",
          "createdAt": FieldValue.serverTimestamp(),
          "favoriteMovies": [],
        });

        _showSuccess("Kayıt başarılı! Giriş sayfasına yönlendiriliyorsunuz...");
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Signin()),
          );
        });
      }
    } catch (e) {
      _showError("Kayıt başarısız: ${e.toString()}");
    }
  }

  // Geçerli e-posta kontrolü için regex (gmail, hotmail, outlook, yahoo)
  bool _isValidEmail(String email) {
    String pattern =
        r"^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com|outlook\.com|yahoo\.com)$";
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  // Şifre kontrolü: en az 8 karakter, bir harf, bir rakam ve bir özel karakter içermeli
  bool _isValidPassword(String password) {
    String pattern =
        r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&.])[A-Za-z\d@$!%*?&.]{8,}$";
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Text(
                'Hoşgeldiniz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Lütfen bilgilerinizi girerek kayıt olun.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 38),
              _buildTextField(
                controller: _nameController,
                hintText: "Ad Soyad",
                icon: FontAwesomeIcons.user,
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: _emailController,
                hintText: "E-Posta",
                icon: FontAwesomeIcons.envelope,
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: _passwordController,
                hintText: "Şifre",
                icon: FontAwesomeIcons.lock,
                obscureText: true,
                suffixIcon: Icons.visibility_off,
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: _confirmPasswordController,
                hintText: "Şifre Tekrarı",
                icon: FontAwesomeIcons.lock,
                obscureText: true,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Kullanıcı sözleşmesini ',
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: 'okudum ve kabul ediyorum',
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            ),
                          ),
                          TextSpan(
                            text:
                                '. Bu sözleşmeyi okuyarak devam ediniz lütfen.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35),
              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: Size(330, 47),
                ),
                child: Text(
                  'Şimdi Kaydol',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(FontAwesomeIcons.google),
                  SizedBox(width: 16),
                  _buildSocialButton(FontAwesomeIcons.apple),
                  SizedBox(width: 16),
                  _buildSocialButton(FontAwesomeIcons.facebookF),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Zaten bir hesabın var mı? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signin()),
                      );
                    },
                    child: Text(
                      'Giriş Yap!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    IconData? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon:
            suffixIcon != null ? Icon(suffixIcon, color: Colors.white) : null,
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey.shade700, width: 1),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromARGB(68, 158, 158, 158),
          width: 1,
        ),
      ),
      child: Center(child: FaIcon(icon, color: Colors.white, size: 24)),
    );
  }
}
