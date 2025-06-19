import 'package:firebase_database/firebase_database.dart';
import '../models/movie_model.dart';

class MovieService {
  final _db = FirebaseDatabase.instance.ref();
  final _tag = "MovieService";

  // 🟡 Lấy tất cả phim
  Future<List<Movie>> fetchAllMovies() async {
    final movieSnapshot = await _db.child('movies').get();
    if (!movieSnapshot.exists) return [];

    final data = movieSnapshot.value;
    List<String> movieIds = [];

    if (data is List) {
      movieIds =
          data
              .where((e) => e != null && e['id'] != null)
              .map((e) => e['id'] as String)
              .toList();
    } else if (data is Map) {
      movieIds =
          data.values
              .where((e) => e != null && e['id'] != null)
              .map((e) => e['id'] as String)
              .toList();
    }

    return fetchMoviesByIds(movieIds);
  }

  // 🔍 Lấy các phim theo genre
  Future<List<Movie>> fetchMoviesByGenre(String genreSlug) async {
    final genreSnapshot = await _db.child('genres').get();
    if (!genreSnapshot.exists) return [];

    final data = genreSnapshot.value;
    List<String> movieIds = [];

    if (data is List) {
      // Iterate through the map entries
      for (var entry in data) {
        final genreMap = Map<String, dynamic>.from(entry);
        final genreTitle = genreMap['slug']?.toString().trim().toLowerCase();

        if (genreTitle == genreSlug.trim().toLowerCase()) {
          // Handle both List and Map structures for movies
          final moviesData = genreMap['movies'];
          if (moviesData is List) {
            movieIds = List<String>.from(moviesData);
          } else if (moviesData is Map) {
            movieIds = moviesData.keys.cast<String>().toList();
          }
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

  Future<Movie?> fetchMovieById(String id) async {
    final snapshot = await _db.child('movies').get();
    if (!snapshot.exists) return null;

    final data = snapshot.value;

    if (data is Map) {
      final values = data.values.whereType<Map<Object?, Object?>>();
      for (var raw in values) {
        final movieMap = raw.map(
          (key, value) => MapEntry(key.toString(), value),
        );
        if (movieMap['id'] == id) {
          return Movie.fromJson(Map<String, dynamic>.from(movieMap));
        }
      }
    } else if (data is List) {
      final values = data.whereType<Map<Object?, Object?>>();
      for (var raw in values) {
        final movieMap = raw.map(
          (key, value) => MapEntry(key.toString(), value),
        );
        if (movieMap['id'] == id) {
          return Movie.fromJson(Map<String, dynamic>.from(movieMap));
        }
      }
    }

    return null;
  }
}
