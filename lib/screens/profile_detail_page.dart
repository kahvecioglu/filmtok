import 'package:filmtok/screens/homepage.dart';
import 'package:filmtok/screens/profile_photo.dart';
import 'package:filmtok/screens/signin.dart';
import 'package:filmtok/screens/teklif.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../state_management/favorite_provider.dart';
import '../cards/card_profile_detay.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert'; // base64encode için

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Yükleniyor...";
  String userId = "ID: ---";
  String fullUserId = "";
  // Varsayılan profil fotoğrafı URL'si (fallback)
  String profilePhotoUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  String _shortenId(String uid) {
    if (uid.length > 10) {
      return "${uid.substring(0, 4)}...${uid.substring(uid.length - 4)}";
    }
    return uid;
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['fullName'] ?? "Bilinmeyen Kullanıcı";
            fullUserId = userDoc['id'] ?? '---';
            userId = "ID: ${_shortenId(fullUserId)}";
            // profileUrl varsa onu kullan, yoksa varsayılanı bırak.
            if (userDoc['profileUrl'] != null &&
                userDoc['profileUrl'].toString().isNotEmpty) {
              profilePhotoUrl = userDoc['profileUrl'];
            }
          });
        }
      }
    } catch (e) {
      print("Kullanıcı verileri alınamadı: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: const Text(
          "Profil Detayı",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 1),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return TeklifSayfasi();
                  },
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.solidGem,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                "Sınırlı Teklif",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(child: Text("Çıkış başarılı.")),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Signin()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Çıkış yapılırken hata oluştu: $e"),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Artık profil fotoğrafı URL'sini kullanıyoruz.
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey, // Arkaplan rengi
                  backgroundImage:
                      profilePhotoUrl.isNotEmpty
                          ? MemoryImage(
                            base64Decode(profilePhotoUrl),
                          ) // Base64'ü çözüp göster
                          : null, // Eğer boşsa varsayılan göster
                  child:
                      profilePhotoUrl.isEmpty
                          ? Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.white,
                          ) // Varsayılan ikon
                          : null,
                ),

                const SizedBox(width: 16),
                // Expanded kullanarak metin alanının esnemesini sağlıyoruz.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Tam Kullanıcı ID"),
                                content: SelectableText(fullUserId),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Kapat"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: SizedBox(
                          width: 150,
                          child: Text(
                            userId,
                            style: const TextStyle(color: Colors.grey),
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePhotoScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Fotoğraf Ekle",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Beğendiğim Filmler",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<FavoriteMoviesProvider>(
                builder: (context, favoriteMoviesProvider, child) {
                  final favoriteMovies = favoriteMoviesProvider.favoriteMovies;
                  if (favoriteMovies.isEmpty) {
                    return const Center(
                      child: Text(
                        "Henüz favori film eklenmedi.",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  }
                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                    children:
                        favoriteMovies.map((movie) {
                          return MovieCardd(
                            imageUrl: movie['imageUrl'] ?? '',
                            title: movie['title'] ?? 'Bilinmeyen Film',
                            subtitle: "Favori Film",
                            movie: movie,
                            movieId: movie["id"],
                          );
                        }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
