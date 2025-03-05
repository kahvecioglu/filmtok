import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieApiService {
  final String _apiKey =
      "4bdff4acee3f542f2b98938bea396065"; // TMDb API anahtarı
  final String _url = "https://api.themoviedb.org/3/";

  // Popüler filmleri çekerken sayfa parametresi ekliyoruz
  Future<List<dynamic>> fetchMovies(int page) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey&page=$page",
        ), // Popüler filmleri alıyoruz
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        // Filmler listesine ulaşarak geri döndürüyoruz
        return data['results'] ?? []; // "results" anahtarındaki filmler
      } else {
        throw Exception(
          'API request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Hata: $e");
      return []; // Hata durumunda boş liste döndür
    }
  }
}
