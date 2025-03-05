import 'package:filmtok/signin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
                'Tempus varius a vitae interdum id tortor elementum tristique eleifend at.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 38),
              _buildTextField(
                hintText: "Ad Soyad",
                icon: FontAwesomeIcons.user,
                obscureText: true,
              ),
              SizedBox(height: 15),
              _buildTextField(
                hintText: "E-Posta",
                icon: FontAwesomeIcons.envelope,
                obscureText: true,
              ),
              SizedBox(height: 15),
              _buildTextField(
                hintText: "Şifre",
                icon: FontAwesomeIcons.lock,
                obscureText: true,
                suffixIcon: Icons.visibility_off,
              ),
              SizedBox(height: 15),
              _buildTextField(
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: Size(330, 47), // Genişlik: 200, Yükseklik: 50
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
                    style: TextStyle(
                      color: Colors.grey,
                    ), // Gri renkte normal text
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Signin(),
                        ), // Signup sayfasına yönlendirir
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
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none, // Varsayılan border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: const Color.fromARGB(56, 158, 158, 158),
            width: 1,
          ), // Normal border
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
        border: Border.all(
          color: const Color.fromARGB(68, 158, 158, 158), // gri çizgi
          width: 1, // Çizginin kalınlığı
        ),
      ),
      child: Center(child: FaIcon(icon, color: Colors.white, size: 24)),
    );
  }
}
