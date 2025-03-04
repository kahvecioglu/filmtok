import 'package:filmtok/signup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Signin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 32),

              // E-Posta Girişi
              _buildTextField(
                hintText: "E-Posta",
                icon: Icons.mail_outline,
                obscureText: false,
              ),
              SizedBox(height: 16),

              // Şifre Girişi
              _buildTextField(
                hintText: "Şifre",
                icon: Icons.lock_outline,
                obscureText: true,
                suffixIcon: Icons.visibility_off,
              ),
              SizedBox(height: 10),

              // Şifremi Unuttum
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

              // Giriş Yap Butonu
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Giriş Yap",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Sosyal Medya Giriş Butonları
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(FontAwesomeIcons.google),
                  SizedBox(width: 16),
                  _buildSocialButton(FontAwesomeIcons.apple),
                  SizedBox(width: 16),
                  _buildSocialButton(FontAwesomeIcons.facebook),
                ],
              ),
              SizedBox(height: 20),

              // Kayıt Ol Linki
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
                        MaterialPageRoute(
                          builder: (context) => SignupPage(),
                        ), // Signup sayfasına yönlendirir
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
    );
  }

  // Giriş alanları için özel metod
  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    IconData? suffixIcon,
  }) {
    return TextField(
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
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Sosyal medya butonları için özel metod
  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FaIcon(icon, color: Colors.white, size: 24),
    );
  }
}
