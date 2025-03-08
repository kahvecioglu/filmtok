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
        title: Text(
          'Profil Detayı',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: 'EuclidCircularA',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color.fromARGB(
                  26,
                  255,
                  255,
                  255,
                ), // Kenarlık için %10 beyaz
                width: 1,
              ),
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24, // Boyut
            ),
          ),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              ),
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
            child: Column(
              children: [
                Text(
                  'Fotoğraflarınızı Yükleyin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'EuclidCircularA',
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Resources out incentivize\n relaxation floor loss cc.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'EuclidCircularA',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 168,
                    height: 164,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color.fromARGB(
                          26,
                          255,
                          255,
                          255,
                        ), // Kenarlık için %10 beyaz
                        width: 1,
                      ),
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
                            ? Icon(
                              Icons.add,
                              color: Colors.white.withOpacity(0.5),
                              size: 26,
                            )
                            : null,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: 54,
                  width: 350,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE50914),
                      padding: EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _isUploading ? null : _uploadImage,
                    child:
                        _isUploading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              'Devam Et',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'EuclidCircularA',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
