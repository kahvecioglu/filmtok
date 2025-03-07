import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filmtok/state_management/favorite_provider.dart';

class MovieCardd extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final int movieId;
  final Map<String, dynamic> movie;

  const MovieCardd({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.movieId,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        Positioned(
          top: 1,
          right: 1,
          child: IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red, size: 30),
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
