import 'package:flutter/material.dart';

class FavoriteMoviesProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _favoriteMovies = [];

  List<Map<String, dynamic>> get favoriteMovies => _favoriteMovies;

  void toggleFavorite(Map<String, dynamic> movie) {
    final existingIndex = _favoriteMovies.indexWhere(
      (item) => item['id'] == movie['id'],
    );

    if (existingIndex >= 0) {
      // Eğer film zaten favorilerde varsa, kaldır
      _favoriteMovies.removeAt(existingIndex);
    } else {
      // Favorilere ekle
      _favoriteMovies.add(movie);
    }

    notifyListeners();
  }

  bool isFavorite(int id) {
    return _favoriteMovies.any((movie) => movie['id'] == id);
  }
}
