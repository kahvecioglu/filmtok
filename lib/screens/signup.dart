import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmtok/screens/homepage.dart';
import 'package:filmtok/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  // Bool değişkenleri: Şifre görünürlüğünü kontrol etmek için
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null)
        return; // Kullanıcı giriş yapmazsa işlemi iptal et

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .get();

        if (!userDoc.exists) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .set({
                "id": user.uid,
                "fullName": user.displayName ?? "", // Kullanıcı adı varsa ekle
                "email": user.email,
                "profileUrl": "", // Profil fotoğrafı varsa ekle
                "createdAt": FieldValue.serverTimestamp(),
                "favoriteMovies": [],
              });
        }

        // ✅ Kullanıcıya giriş başarılı mesajı göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text('Google ile giriş başarılı!')),
            backgroundColor: Colors.green,
          ),
        );

        // ✅ HomeScreen sayfasına yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      print("Google ile giriş başarısız: $e");

      // ❌ Kullanıcıya hata mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google ile giriş başarısız!'),
          backgroundColor: Colors.red,
        ),
      );
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
        backgroundColor: Colors.green,
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
              SizedBox(height: 110),
              Text(
                'Hoşgeldiniz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'EuclidCircularA',
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Tempus varius a vitae interdum id tortor\n elementum tristique eleifend at.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'EuclidCircularA',
                ),
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
                obscureText: _obscurePassword,
                suffixIcon:
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                onSuffixTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: _confirmPasswordController,
                hintText: "Şifre Tekrarı",
                icon: FontAwesomeIcons.lock,
                obscureText: _obscureConfirmPassword,
                suffixIcon:
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                onSuffixTap: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Kullanıcı sözleşmesini ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'EuclidCircularA',
                        ),
                        children: [
                          TextSpan(
                            text: 'okudum ve kabul ediyorum',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'EuclidCircularA',
                              fontSize: 12,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            ),
                          ),
                          TextSpan(
                            text:
                                '. Bu sözleşmeyi okuyarak devam ediniz lütfen.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'EuclidCircularA',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35),
              SizedBox(
                width: 324,
                height: 54,
                child: ElevatedButton(
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    minimumSize: Size(330, 47),
                  ),
                  child: Text(
                    'Şimdi Kaydol',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'EuclidCircularA',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(FontAwesomeIcons.google, "google"),
                  SizedBox(width: 16),
                  _buildSocialButton(FontAwesomeIcons.apple, "apple"),
                  SizedBox(width: 16),
                  _buildSocialButton(FontAwesomeIcons.facebookF, "facebook"),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Zaten bir hesabın var mı? ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'EuclidCircularA',
                      fontSize: 12,
                    ),
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
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'EuclidCircularA',
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
    VoidCallback? onSuffixTap,
  }) {
    return SizedBox(
      height: 54,
      width: 324,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontFamily: 'EuclidCircularA',
          ),

          prefixIcon: Icon(icon, color: Colors.white, size: 15),
          suffixIcon:
              suffixIcon != null
                  ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(suffixIcon, color: Colors.white, size: 20),
                  )
                  : null,
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
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String a) {
    return InkWell(
      onTap: () {
        if (a == "google") {
          signInWithGoogle(context);
        } else if (a == "apple") {
          // Apple ile giriş yapma metodunuzu çağırın
        } else if (a == "facebook") {
          // Facebook ile giriş yapma metodunuzu çağırın
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1), // İç kısım için %10 beyaz
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color.fromARGB(51, 255, 255, 255), // Kenarlık için %20 beyaz
            width: 1,
          ),
        ),
        child: Center(child: FaIcon(icon, color: Colors.white, size: 20)),
      ),
    );
  }
}
