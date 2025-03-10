import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:filmtok/screens/homepage.dart';
import 'package:filmtok/screens/profile_photo.dart';
import 'package:filmtok/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _obscurePassword = true; // Şifre gizli mi açık mı başta böyle dedim

  Future<void> signIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage =
          "Giriş yapılamadı. Lütfen e-posta ve şifrenizi kontrol ediniz.";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Bir hata oluştu. Lütfen e-posta ve şifrenizi kontrol ediniz.",
          ),
        ),
      );
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

  Future<void> resetpassword() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lütfen e-posta adresinizi girin."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Şifre sıfırlama e-postası gönderildi."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 290),
                Text(
                  "Merhabalar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,

                    fontFamily: 'EuclidCircularA',
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 8),
                Text(
                  "Tempus varius a vitae interdum id\ntortor elementum tristique eleifend at.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'EuclidCircularA',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 32),
                _buildTextField(
                  controller: emailController,
                  hintText: "E-Posta",
                  icon: Icons.mail_outline,
                  obscureText: false,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: passwordController,
                  hintText: "Şifre",
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword, // Şifre görünürlüğü
                  suffixIcon:
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                  onSuffixTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      resetpassword();
                    },
                    child: Text(
                      "Şifremi unuttum",
                      style: TextStyle(
                        fontFamily: 'EuclidCircularA',
                        color: Colors.white,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE50914),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    minimumSize: Size(330, 47),
                  ),
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'EuclidCircularA',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 30),
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
                      "Bir hesabın yok mu?",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'EuclidCircularA',
                      ),
                    ),
                    SizedBox(width: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: Text(
                        "Kayıt Ol!",
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
      width: 324,
      height: 54,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color.fromARGB(124, 255, 255, 255),
            fontSize: 12,
            fontFamily: 'EuclidCircularA',
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: SizedBox(
            width: 17,
            height: 15,
            child: SizedBox(
              width: 20,
              height: 17,
              child: Icon(
                icon,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 15,
              ),
            ),
          ),

          suffixIcon:
              suffixIcon != null
                  ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(suffixIcon, color: Colors.white),
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
