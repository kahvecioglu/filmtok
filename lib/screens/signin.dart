import 'package:firebase_auth/firebase_auth.dart';
import 'package:filmtok/screens/homepage.dart';
import 'package:filmtok/screens/profile_photo.dart';
import 'package:filmtok/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş başarısız: ${e.toString()}")),
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
                SizedBox(height: 296),
                Text(
                  "Merhabalar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Tempus varius a vitae interdum id\ntortor elementum tristique eleifend at.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14),
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
                  child: Text(
                    "Şifremi unuttum",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    minimumSize: Size(330, 47),
                  ),
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(height: 30),
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
                      "Bir hesabın yok mu?",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
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
                          fontSize: 14,
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
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: Colors.white),
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
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade700, width: 1),
      ),
      child: Center(child: FaIcon(icon, color: Colors.white, size: 24)),
    );
  }
}
