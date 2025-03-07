import 'dart:math'; // Rastgele sayı üretmek için
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filmtok/services/movieapi.dart';
import 'package:filmtok/cards/card_anasayfa.dart';
import 'package:filmtok/screens/profile_detail_page.dart';
import 'package:filmtok/state_management/favorite_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  List<dynamic> _movies = [];
  bool _isLoading = true;
  int _currentPage = 1;
  final int _totalPages = 500; // TMDb API maksimum sayfa sınırı 500

  @override
  void initState() {
    super.initState();
    fetchMovies();
    // Favori filmleri Firestore'dan çekip provider'a ekle
    Future.microtask(
      () =>
          Provider.of<FavoriteMoviesProvider>(
            context,
            listen: false,
          ).fetchFavoriteMovies(),
    );
  }

  Future<void> fetchMovies() async {
    var movieApiService = MovieApiService();

    // 1 ile 500 arasında rastgele bir sayfa seç
    int randomPage = Random().nextInt(500) + 1;

    var response = await movieApiService.fetchMovies(randomPage);

    setState(() {
      _movies = response;
      _currentPage = randomPage;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [_buildHomeContent(), ProfileScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: _movies.length,
          itemBuilder: (context, index) {
            final movie = {
              'id': _movies[index]['id'],
              'title': _movies[index]['title'] ?? 'Bilinmeyen Film',
              'description':
                  _movies[index]['overview'] ?? 'Açıklama bulunamadı',
              'imageUrl':
                  _movies[index]['poster_path'] != null
                      ? 'https://image.tmdb.org/t/p/w500${_movies[index]['poster_path']}'
                      : '',
            };

            return Stack(
              children: [
                MovieCard(
                  title: movie['title'],
                  description: movie['description'],
                  imageUrl: movie['imageUrl'],
                ),
                Positioned(
                  bottom: 100,
                  right: 20,
                  child: Consumer<FavoriteMoviesProvider>(
                    builder: (context, favoriteMovies, child) {
                      final isFavorite = favoriteMovies.isFavorite(movie['id']);

                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          favoriteMovies.toggleFavorite(movie);
                          print(
                            "Favori Filmler: ${favoriteMovies.favoriteMovies}",
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
  }
}
