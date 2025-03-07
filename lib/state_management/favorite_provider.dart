import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteMoviesProvider with ChangeNotifier {
  List<Map<String, dynamic>> _favoriteMovies = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> get favoriteMovies => _favoriteMovies;

  /// Firestore'dan favori filmleri çekme
  Future<void> fetchFavoriteMovies() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

    if (userDoc.exists && userDoc.data() != null) {
      final List<dynamic> favorites = userDoc.data()!["favoriteMovies"] ?? [];
      _favoriteMovies = List<Map<String, dynamic>>.from(favorites);
      notifyListeners();
    }
  }

  /// Favorilere ekleme/çıkarma işlemi
  Future<void> toggleFavorite(Map<String, dynamic> movie) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid);

    final existingIndex = _favoriteMovies.indexWhere(
      (item) => item['id'] == movie['id'],
    );

    if (existingIndex >= 0) {
      // Favorilerden kaldır
      _favoriteMovies.removeAt(existingIndex);
      await userRef.update({
        "favoriteMovies": FieldValue.arrayRemove([movie]),
      });
    } else {
      // Favorilere ekle
      _favoriteMovies.add(movie);
      await userRef.update({
        "favoriteMovies": FieldValue.arrayUnion([movie]),
      });
    }

    notifyListeners();
  }

  /// Filmin favorilerde olup olmadığını kontrol etme
  bool isFavorite(int id) {
    return _favoriteMovies.any((movie) => movie['id'] == id);
  }
}
