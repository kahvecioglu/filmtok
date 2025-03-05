import 'package:flutter/material.dart';

class MovieCard extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;

  MovieCard({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height, // Tam ekran
      decoration: BoxDecoration(color: Colors.black),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(widget.imageUrl, fit: BoxFit.cover),
          ),

          // Başlık ve açıklama alanı
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LOGO
                  // LOGO (Yuvarlak)
                  ClipOval(
                    child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3mk85oBReRfPcS7cZzlyECuXtsGNyDJsoAw&s",
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover, // Resmi kırpmadan sığdır
                    ),
                  ),

                  SizedBox(width: 10), // Boşluk bırak
                  // Başlık ve Açıklama (Column içinde)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Film İsmi
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Uzun isimlerde "..."
                        ),
                        SizedBox(height: 4),

                        // Açıklama + Daha Fazlası (Yan Yana)
                        _buildDescriptionText(widget.description),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Açıklama + "Daha Fazlası" Butonu (Yan Yana)
  Widget _buildDescriptionText(String description) {
    if (_showFullDescription || description.length <= 75) {
      return Text(
        description,
        style: TextStyle(color: Colors.white70, fontSize: 16),
      );
    } else {
      String shortText = description.substring(0, 75); // İlk 60 karakter
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: shortText, // Kısaltılmış açıklama
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showFullDescription = true;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    "Daha Fazlası",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
}
