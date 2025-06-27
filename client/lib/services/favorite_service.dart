import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_model.dart';
import '../models/movie_model.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  static FavoriteService get instance => _instance;
  FavoriteService._internal();

  final _database = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser?.uid ?? '';

  DatabaseReference get _favoritesRef =>
      _database.ref().child('users').child(userId).child('favorites');

  // Lấy tất cả yêu thích
  Future<List<Favorite>> getFavorites() async {
    final snapshot = await _favoritesRef.get();
    if (snapshot.exists) {
      final map = Map<String, dynamic>.from(snapshot.value as Map);
      return map.entries.map((e) {
        return Favorite.fromJson(Map<String, dynamic>.from(e.value));
      }).toList();
    }
    return [];
  }

  // Lấy phim yêu thích
  Future<List<Favorite>> getFavoriteMovies() async {
    final favorites = await getFavorites();
    return favorites.where((f) => f.type == FavoriteType.movie).toList();
  }

  // Lấy diễn viên yêu thích
  Future<List<Favorite>> getFavoriteActors() async {
    final favorites = await getFavorites();
    return favorites.where((f) => f.type == FavoriteType.actor).toList();
  }

  // Kiểm tra phim có trong yêu thích không
  Future<bool> isMovieFavorite(String movieId) async {
    final snapshot = await _favoritesRef.child('movie_$movieId').get();
    return snapshot.exists;
  }

  // Kiểm tra diễn viên có trong yêu thích không
  Future<bool> isActorFavorite(String actorId) async {
    final snapshot = await _favoritesRef.child('actor_$actorId').get();
    return snapshot.exists;
  }

  // Thêm phim vào yêu thích
  Future<void> addMovieToFavorites(Movie movie) async {
    final id = 'movie_${movie.id}';
    final ref = _favoritesRef.child(id);
    final snapshot = await ref.get();

    if (!snapshot.exists) {
      final favorite = Favorite(
        id: id,
        type: FavoriteType.movie,
        addedAt: DateTime.now(),
        movie: movie,
      );
      await ref.set(favorite.toJson());
      print('✅ Added movie to favorites: ${movie.title}');
    }
  }

  // Thêm diễn viên vào yêu thích
  Future<void> addActorToFavorites(Actor actor) async {
    final id = 'actor_${actor.id}';
    final ref = _favoritesRef.child(id);
    final snapshot = await ref.get();

    if (!snapshot.exists) {
      final favorite = Favorite(
        id: id,
        type: FavoriteType.actor,
        addedAt: DateTime.now(),
        actor: actor,
      );
      await ref.set(favorite.toJson());
      print('✅ Added actor to favorites: ${actor.name}');
    }
  }

  // Xóa khỏi yêu thích
  Future<void> removeFromFavorites(String favoriteId) async {
    await _favoritesRef.child(favoriteId).remove();
    print('✅ Removed from favorites: $favoriteId');
  }

  // Xóa nhiều khỏi yêu thích
  Future<void> removeMultipleFromFavorites(List<String> favoriteIds) async {
    for (final id in favoriteIds) {
      await _favoritesRef.child(id).remove();
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
}
