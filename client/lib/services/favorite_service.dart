import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_model.dart';
import '../models/movie_model.dart';

class FavoriteService {
  static const String _favoritesKey = 'favorites';
  static FavoriteService? _instance;

  FavoriteService._();

  static FavoriteService get instance {
    _instance ??= FavoriteService._();
    return _instance!;
  }

  // Lấy danh sách yêu thích
  Future<List<Favorite>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

      return favoritesJson
          .map((json) => Favorite.fromJson(jsonDecode(json)))
          .toList()
        ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      return [];
    }
  }

  // Lấy danh sách phim yêu thích
  Future<List<Favorite>> getFavoriteMovies() async {
    final favorites = await getFavorites();
    return favorites.where((f) => f.type == FavoriteType.movie).toList();
  }

  // Lấy danh sách diễn viên yêu thích
  Future<List<Favorite>> getFavoriteActors() async {
    final favorites = await getFavorites();
    return favorites.where((f) => f.type == FavoriteType.actor).toList();
  }

  // Thêm phim vào yêu thích
  Future<void> addMovieToFavorites(Movie movie) async {
    try {
      final favorites = await getFavorites();

      // Kiểm tra đã có chưa
      final exists = favorites.any(
        (f) => f.type == FavoriteType.movie && f.movie?.id == movie.id,
      );

      if (!exists) {
        final favorite = Favorite(
          id: 'movie_${movie.id}_${DateTime.now().millisecondsSinceEpoch}',
          type: FavoriteType.movie,
          addedAt: DateTime.now(),
          movie: movie,
        );

        favorites.insert(0, favorite);
        await _saveFavorites(favorites);
      }
    } catch (e) {
      debugPrint('Error adding movie to favorites: $e');
    }
  }

  // Thêm diễn viên vào yêu thích
  Future<void> addActorToFavorites(Actor actor) async {
    try {
      final favorites = await getFavorites();

      // Kiểm tra đã có chưa
      final exists = favorites.any(
        (f) => f.type == FavoriteType.actor && f.actor?.id == actor.id,
      );

      if (!exists) {
        final favorite = Favorite(
          id: 'actor_${actor.id}_${DateTime.now().millisecondsSinceEpoch}',
          type: FavoriteType.actor,
          addedAt: DateTime.now(),
          actor: actor,
        );

        favorites.insert(0, favorite);
        await _saveFavorites(favorites);
      }
    } catch (e) {
      debugPrint('Error adding actor to favorites: $e');
    }
  }

  // Xóa khỏi yêu thích
  Future<void> removeFromFavorites(String favoriteId) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((f) => f.id == favoriteId);
      await _saveFavorites(favorites);
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
    }
  }

  // Xóa nhiều khỏi yêu thích
  Future<void> removeMultipleFromFavorites(List<String> favoriteIds) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((f) => favoriteIds.contains(f.id));
      await _saveFavorites(favorites);
    } catch (e) {
      debugPrint('Error removing multiple from favorites: $e');
    }
  }

  // Kiểm tra phim có trong yêu thích không
  Future<bool> isMovieFavorite(String movieId) async {
    final favorites = await getFavorites();
    return favorites.any(
      (f) => f.type == FavoriteType.movie && f.movie?.id == movieId,
    );
  }

  // Kiểm tra diễn viên có trong yêu thích không
  Future<bool> isActorFavorite(String actorId) async {
    final favorites = await getFavorites();
    return favorites.any(
      (f) => f.type == FavoriteType.actor && f.actor?.id == actorId,
    );
  }

  // Xóa toàn bộ yêu thích
  Future<void> clearAllFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }

  // Tìm kiếm trong yêu thích
  Future<List<Favorite>> searchFavorites(String query) async {
    final favorites = await getFavorites();

    if (query.isEmpty) return favorites;

    return favorites.where((f) {
      return f.title.toLowerCase().contains(query.toLowerCase()) ||
          f.subtitle.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Lưu danh sách yêu thích
  Future<void> _saveFavorites(List<Favorite> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = favorites.map((f) => jsonEncode(f.toJson())).toList();
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }
}
