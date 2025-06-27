import 'movie_model.dart';

enum FavoriteType { movie, actor }

class Favorite {
  final String id;
  final FavoriteType type;
  final DateTime addedAt;

  // For movies
  final Movie? movie;

  // For actors
  final Actor? actor;

  Favorite({
    required this.id,
    required this.type,
    required this.addedAt,
    this.movie,
    this.actor,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'addedAt': addedAt.toIso8601String(),
      'movie': movie?.toJson(),
      'actor': actor?.toJson(),
    };
  }

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      type: FavoriteType.values.firstWhere((e) => e.name == json['type']),
      addedAt: DateTime.parse(json['addedAt']),
      movie:
          json['movie'] != null
              ? Movie.fromJson(Map<String, dynamic>.from(json['movie']))
              : null,
      actor:
          json['actor'] != null
              ? Actor.fromJson(Map<String, dynamic>.from(json['actor']))
              : null,
    );
  }

  // Helper getters
  String get title => movie?.title ?? actor?.name ?? '';
  String get subtitle => movie?.englishTitle ?? actor?.biography ?? '';
  String get imageUrl => movie?.posterUrl ?? actor?.profileUrl ?? '';
  String get year => movie?.year ?? '';
}

class Actor {
  final String id;
  final String name;
  final String biography;
  final String profileUrl;
  final String birthDate;
  final String birthPlace;
  final List<String> knownFor;

  Actor({
    required this.id,
    required this.name,
    this.biography = '',
    this.profileUrl = '',
    this.birthDate = '',
    this.birthPlace = '',
    this.knownFor = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'biography': biography,
      'profileUrl': profileUrl,
      'birthDate': birthDate,
      'birthPlace': birthPlace,
      'knownFor': knownFor,
    };
  }

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      name: json['name'],
      biography: json['biography'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      birthDate: json['birthDate'] ?? '',
      birthPlace: json['birthPlace'] ?? '',
      knownFor: List<String>.from(json['knownFor'] ?? []),
    );
  }
}
