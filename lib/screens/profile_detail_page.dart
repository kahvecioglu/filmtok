// profile_screen.dart
import 'package:flutter/material.dart';
import '../cards/card_profile_detay.dart'; // MovieCardd widget'ını buraya import ettik

class ProfileScreen extends StatelessWidget {
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil bilgileri
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
                    const Text(
                      "Ayça Aydoğan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "ID: 245677",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("Sınırlı Teklif"),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("Fotoğraf Ekle"),
                    ),
                  ],
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
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
                children: [
                  MovieCardd(
                    imageUrl:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNg5NCXA36zZ1OEQGLHDpjqsSM9lypoKLf5w&s",
                    title: "Aşk, Ekmek, Hayaller",
                    subtitle: "Adam Yapım",
                  ),
                  MovieCardd(
                    imageUrl:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNg5NCXA36zZ1OEQGLHDpjqsSM9lypoKLf5w&s",
                    title: "Gece Karanlık",
                    subtitle: "Fox Studios",
                  ),
                  MovieCardd(
                    imageUrl:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNg5NCXA36zZ1OEQGLHDpjqsSM9lypoKLf5w&s",
                    title: "Aşk, Ekmek, Hayaller",
                    subtitle: "Adam Yapım",
                  ),
                  MovieCardd(
                    imageUrl:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNg5NCXA36zZ1OEQGLHDpjqsSM9lypoKLf5w&s",
                    title: "Gece Karanlık",
                    subtitle: "Fox Studios",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
