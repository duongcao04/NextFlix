import 'package:firebase_database/firebase_database.dart';
import '../models/movie_model.dart';

class MovieService {
  final _db = FirebaseDatabase.instance.ref();

  // 🟡 Lấy tất cả phim
  Future<List<Movie>> fetchAllMovies() async {
    final snapshot = await _db.child('movies').get();
    if (!snapshot.exists) return [];

    final data = snapshot.value;

    if (data is List) {
      return data
          .where((e) => e != null)
          .map((e) => Movie.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else if (data is Map) {
      return data.values
          .where((e) => e != null)
          .map((e) => Movie.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      return [];
    }
  }

  // 🔍 Lấy các phim theo genre (chưa dùng nếu không có field 'genre')

  Future<List<Movie>> fetchMoviesByGenre(String genreName) async {
    final genreSnapshot = await _db.child('genres').get();
    if (!genreSnapshot.exists) return [];

    final data = genreSnapshot.value;
    List<String> movieIds = [];

    if (data is Map) {
      for (var genre in data.values) {
        final genreMap = Map<String, dynamic>.from(genre);
        final genreTitle = genreMap['name']?.toString().trim().toLowerCase();
        if (genreTitle == genreName.trim().toLowerCase()) {
          movieIds = List<String>.from(genreMap['movies'] ?? []);
          break;
        }
      }
    }

    return fetchMoviesByIds(movieIds);
  }

  // 🎯 Lấy danh sách phim nổi bật từ featured_movies
  Future<List<Movie>> fetchFeaturedMovies() async {
    final featuredSnapshot = await _db.child('featured_movies').get();
    if (!featuredSnapshot.exists) return [];

    final data = featuredSnapshot.value;
    List<String> movieIds = [];

    if (data is List) {
      movieIds =
          data
              .where((e) => e != null && e['movie'] != null)
              .map((e) => e['movie'] as String)
              .toList();
    } else if (data is Map) {
      movieIds =
          data.values
              .where((e) => e != null && e['movie'] != null)
              .map((e) => e['movie'] as String)
              .toList();
    }

    return fetchMoviesByIds(movieIds);
  }

  // 🔁 Lọc phim theo list ID
  Future<List<Movie>> fetchMoviesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final snapshot = await _db.child('movies').get();
    if (!snapshot.exists) return [];

    final data = snapshot.value;

    Iterable entries;
    if (data is List) {
      entries = data.where((e) => e != null && ids.contains(e['id']));
    } else if (data is Map) {
      entries = data.values.where((e) => e != null && ids.contains(e['id']));
    } else {
      return [];
    }

    return entries
        .map((e) => Movie.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
