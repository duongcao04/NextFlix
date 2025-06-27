import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:nextflix/models/watch_history_model.dart';

class UserModel extends Equatable {
  final String? id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? address;
  final UserRole role;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? customData;
  final List<WatchHistory> watchHistory;
  final List<String> wishlist;
  final List<String> searchRecently;

  const UserModel({
    this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.dateOfBirth,
    this.address,
    this.role = UserRole.user,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.customData,
    this.watchHistory = const [],
    this.wishlist = const [],
    this.searchRecently = const [],
  });

  // Create from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      phoneNumber: data['phoneNumber'],
      dateOfBirth:
          data['dateOfBirth'] != null
              ? (data['dateOfBirth'] as Timestamp).toDate()
              : null,
      address: data['address'],
      role: UserRole.values.firstWhere(
        (role) => role.name == data['role'],
        orElse: () => UserRole.user,
      ),
      isActive: data['isActive'] ?? true,
      createdAt:
          data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : null,
      updatedAt:
          data['updatedAt'] != null
              ? (data['updatedAt'] as Timestamp).toDate()
              : null,
      customData: data['customData'],
      watchHistory:
          data['watchHistory'] != null
              ? (data['watchHistory'] as List)
                  .map((movie) => WatchHistory.fromJson(movie))
                  .toList()
              : [],
      wishlist:
          data['wishlist'] != null ? List<String>.from(data['wishlist']) : [],
      searchRecently:
          data['searchRecently'] != null
              ? List<String>.from(data['searchRecently'])
              : [],
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'dateOfBirth':
          dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'address': address,
      'role': role.name,
      'isActive': isActive,
      'customData': customData,
      'watchHistory': watchHistory.map((movie) => movie.toJson()).toList(),
      'wishlist': wishlist,
      'searchRecently': searchRecently,
      // createdAt and updatedAt will be handled by FirebaseService
    };
  }

  // Create from JSON (for API responses)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth:
          json['dateOfBirth'] != null
              ? DateTime.parse(json['dateOfBirth'])
              : null,
      address: json['address'],
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => UserRole.user,
      ),
      isActive: json['isActive'] ?? true,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      customData: json['customData'],
      watchHistory:
          json['watchHistory'] != null
              ? (json['watchHistory'] as List)
                  .map((movie) => WatchHistory.fromJson(movie))
                  .toList()
              : [],
      wishlist:
          json['wishlist'] != null ? List<String>.from(json['wishlist']) : [],
      searchRecently:
          json['searchRecently'] != null
              ? List<String>.from(json['searchRecently'])
              : [],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'address': address,
      'role': role.name,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'customData': customData,
      'watchHistory': watchHistory.map((movie) => movie.toJson()).toList(),
      'wishlist': wishlist,
      'searchRecently': searchRecently,
    };
  }

  // Copy with method for immutable updates
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? address,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? customData,
    List<WwatchingHistory>? wwatchingHistory,
    List<String>? wishlist,
    List<String>? searchRecently,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      customData: customData ?? this.customData,
      watchHistory: watchHistory ?? this.watchHistory,
      wishlist: wishlist ?? this.wishlist,
      searchRecently: searchRecently ?? this.searchRecently,
    );
  }

  // Helper methods
  String get fullName => displayName ?? email.split('@').first;

  bool get hasProfilePicture => photoURL != null && photoURL!.isNotEmpty;

  bool get isAdmin => role == UserRole.admin;

  bool get isModerator => role == UserRole.moderator;

  int get accountAge {
    if (createdAt == null) return 0;
    return DateTime.now().difference(createdAt!).inDays;
  }

  // New helper methods for movie-related features
  bool hasWatchedMovie(String movieId) {
    return watchHistory.any((movie) => movie.id == movieId);
  }

  bool isInWishlist(String movieId) {
    return wishlist.contains(movieId);
  }

  WatchHistory? getMovieProgress(String movieId) {
    try {
      return watchHistory.firstWhere((movie) => movie.id == movieId);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoURL,
    phoneNumber,
    dateOfBirth,
    address,
    role,
    isActive,
    createdAt,
    updatedAt,
    customData,
    watchHistory,
    wishlist,
    searchRecently,
  ];

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName, role: $role)';
  }
}

// Model for movie recently watched
class WwatchingHistory extends Equatable {
  final String movieId;
  final String movieName;
  final ViewingProgress? viewing;

  const WwatchingHistory({
    required this.movieId,
    required this.movieName,
    this.viewing,
  });

  factory WwatchingHistory.fromJson(Map<String, dynamic> json) {
    return WwatchingHistory(
      movieId: json['movieId'] ?? '',
      movieName: json['movieName'] ?? '',
      viewing:
          json['viewing'] != null
              ? ViewingProgress.fromJson(json['viewing'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'movieName': movieName,
      'viewing': viewing?.toJson(),
    };
  }

  WwatchingHistory copyWith({
    String? movieId,
    String? movieName,
    ViewingProgress? viewing,
  }) {
    return WwatchingHistory(
      movieId: movieId ?? this.movieId,
      movieName: movieName ?? this.movieName,
      viewing: viewing ?? this.viewing,
    );
  }

  @override
  List<Object?> get props => [movieId, movieName, viewing];
}

// Model for viewing progress (for TV series)
class ViewingProgress extends Equatable {
  final String seasonNumber;
  final String episodeNumber;

  const ViewingProgress({
    required this.seasonNumber,
    required this.episodeNumber,
  });

  factory ViewingProgress.fromJson(Map<String, dynamic> json) {
    return ViewingProgress(
      seasonNumber: json['season_number']?.toString() ?? '',
      episodeNumber: json['episode_number']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'season_number': seasonNumber, 'episode_number': episodeNumber};
  }

  ViewingProgress copyWith({String? seasonNumber, String? episodeNumber}) {
    return ViewingProgress(
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
    );
  }

  @override
  List<Object?> get props => [seasonNumber, episodeNumber];
}

enum UserRole { user, moderator, admin }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.user:
        return 'User';
      case UserRole.moderator:
        return 'Moderator';
      case UserRole.admin:
        return 'Administrator';
    }
  }

  int get level {
    switch (this) {
      case UserRole.user:
        return 1;
      case UserRole.moderator:
        return 2;
      case UserRole.admin:
        return 3;
    }
  }
}
