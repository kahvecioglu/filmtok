import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filmtok/state_management/favorite_provider.dart';

class MovieCardd extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String puan;
  final int movieId;
  final Map<String, dynamic> movie;

  const MovieCardd({
    required this.imageUrl,
    required this.title,
    required this.puan,
    required this.movieId,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: 153,
                  height: 213,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'EuclidCircularA',
                  fontWeight: FontWeight.w500,
                ),
                overflow:
                    TextOverflow.ellipsis, // Taşan metin için "..." ekledim
              ),
              Text(
                " Puan   " + puan,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                  fontFamily: 'EuclidCircularA',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 1,
          right: 15,
          child: IconButton(
            icon: const Icon(
              Icons.favorite,
              color: const Color(0xFFE50914),
              size: 30,
            ),
            onPressed: () {
              Provider.of<FavoriteMoviesProvider>(
                context,
                listen: false,
              ).toggleFavorite(movie);
            },
          ),
        ),
      ],
    );
  }
}
