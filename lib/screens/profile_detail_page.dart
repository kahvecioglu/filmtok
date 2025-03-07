import 'package:filmtok/screens/teklif.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../state_management/favorite_provider.dart';
import '../cards/card_profile_detay.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Yükleniyor...";
  String userId = "ID: ---";
  String fullUserId = "";

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
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Profil Detayı",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
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
                FontAwesomeIcons.solidGem, // Alternatif elmas ikonu
                color: Colors.white,
                size: 18,
              ),

              label: const Text(
                "Sınırlı Teklif",
                style: TextStyle(color: Colors.white),
              ),
            ),
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
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    "https://st3.depositphotos.com/6672868/14217/v/450/depositphotos_142179970-stock-illustration-user-profile-icon.jpg",
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Fotoğraf ekleme işlemi buraya eklenecek
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
