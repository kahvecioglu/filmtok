import 'dart:io';
import 'dart:convert'; // base64encode için
import 'package:filmtok/screens/homepage.dart';
import 'package:filmtok/screens/profile_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePhotoScreen extends StatefulWidget {
  @override
  _ProfilePhotoScreenState createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final bytes = await _image!.readAsBytes();
      String base64Image = base64Encode(bytes);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({"profileUrl": base64Image});
      }

      setState(() {
        _isUploading = false;
      });

      // ✅ Yükleme başarılı olduğunda Snackbar göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Profil fotoğrafınız başarıyla yüklendi!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // 1 saniye sonra ProfileScreen'e yönlendir
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      });
    } catch (e) {
      print("Resim yüklenirken hata oluştu: $e");
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Resim yüklenirken hata oluştu, tekrar deneyin."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('Profil Detayı', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Fotoğraflarınızı Yükleyin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Profil fotoğrafınızı yükleyin.',
                style: TextStyle(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(15),
                    image:
                        _image != null
                            ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      _image == null
                          ? Icon(Icons.add, color: Colors.white, size: 40)
                          : null,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isUploading ? null : _uploadImage,
                child:
                    _isUploading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                          'Devam Et',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
