import 'package:flutter/material.dart';
import 'package:filmtok/services/movieapi.dart';
import 'package:filmtok/cards/card_anasayfa.dart'; // Film kartı widget'ını import et
import 'package:filmtok/screens/profile_detail_page.dart'; // Profil sayfasını import et

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
    print(movies);

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
                          return Stack(
                            children: [
                              MovieCard(
                                title:
                                    _movies[index]['title'] ??
                                    'Bilinmeyen Film',
                                description:
                                    _movies[index]['overview'] ??
                                    'Açıklama bulunamadı',
                                imageUrl:
                                    _movies[index]['poster_path'] != null
                                        ? 'https://image.tmdb.org/t/p/w500${_movies[index]['poster_path']}'
                                        : '',
                              ),
                              Positioned(
                                bottom: 100,
                                right: 20,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                ],
              )
              : ProfileScreen(),
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
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
      ),
    );
  }
}
