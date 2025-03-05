import 'package:filmtok/movie_card.dart';
import 'package:filmtok/profile_detail_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> movies = [
    {
      'title': 'Film 1',
      'description': 'İlk film açıklaması burada olacak.',
      'image':
          'https://www.igfhaber.com/static/1-/1-yer-cekimi-1656067170-196.jpg',
    },
    {
      'title': 'Film 2',
      'description': 'İkinci film açıklaması burada olacak.',
      'image':
          'https://www.igfhaber.com/static/1-/1-yer-cekimi-1656067170-196.jpg',
    },
    {
      'title': 'Film 3',
      'description': 'Üçüncü film açıklaması burada olacak.',
      'image':
          'https://www.igfhaber.com/static/1-/1-yer-cekimi-1656067170-196.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _currentIndex == 0
              ? PageView.builder(
                scrollDirection: Axis.vertical, // Dikey kaydırma
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return MovieCard(
                    title: movies[index]['title']!,
                    description: movies[index]['description']!,
                    imageUrl: movies[index]['image']!,
                  );
                },
              )
              : ProfileScreen(), // Profil sayfasına geçiş
      bottomNavigationBar: BottomNavigationBar(
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
