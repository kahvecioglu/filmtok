import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _termsChecked = false; // Kullanıcı sözleşmesi onay durumu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              _buildTextField(
                hintText: "Ad Soayd",
                icon: Icons.person_add_alt_1_outlined,
                obscureText: true,
              ),

              SizedBox(height: 10),
              _buildTextField(
                hintText: "E-Posta",
                icon: Icons.mail_outline,
                obscureText: true,
              ),
              SizedBox(height: 10),
              _buildTextField(
                hintText: "Şifre",
                icon: Icons.lock_outline,
                obscureText: true,
                suffixIcon: Icons.visibility_off,
              ),
              SizedBox(height: 10),
              _buildTextField(
                hintText: "Şifre Tekrarı",
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Kullanıcı sözleşmesini okudum ve kabul ediyorum. Bu sözleşmeyi okuyarak devam ediniz lütfen.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_termsChecked) {
                    // Kayıt işlemleri
                  } else {
                    // Kullanıcı sözleşmesi onaylanmadı uyarısı
                  }
                },
                child: Text('Şimdi Kaydol'),
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.g_mobiledata, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.apple, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.facebook, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Zaten bir hesabın var mı? Giriş Yap!',
                  style: TextStyle(color: Colors.blue),
                ),
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
}
