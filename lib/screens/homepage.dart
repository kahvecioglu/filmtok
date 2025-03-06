import 'package:filmtok/state_management/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filmtok/services/movieapi.dart';
import 'package:filmtok/cards/card_anasayfa.dart';
import 'package:filmtok/screens/profile_detail_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<dynamic> _movies = [];
  bool _isLoading = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    var movieApiService = MovieApiService();
    List<dynamic> movies = await movieApiService.fetchMovies(_currentPage);

    setState(() {
      _movies = movies;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _currentIndex == 0
              ? Stack(
                children: [
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : PageView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _movies.length,
                        itemBuilder: (context, index) {
                          final movie = {
                            'id': _movies[index]['id'],
                            'title':
                                _movies[index]['title'] ?? 'Bilinmeyen Film',
                            'description':
                                _movies[index]['overview'] ??
                                'Açıklama bulunamadı',
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

                              // Kalp Butonu
                              Positioned(
                                bottom: 100,
                                right: 20,
                                child: Consumer<FavoriteMoviesProvider>(
                                  builder: (context, favoriteMovies, child) {
                                    final isFavorite = favoriteMovies
                                        .isFavorite(movie['id']);

                                    return IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            isFavorite
                                                ? Colors.red
                                                : Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        favoriteMovies.toggleFavorite(movie);

                                        // EKLENEN/ÇIKARILAN FİLMLERİ TERMİNALE YAZDIRDIM

                                        print(
                                          "Favori Filmler: ${favoriteMovies.favoriteMovies.toString()}",
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                ],
              )
              : ProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
