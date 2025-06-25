import 'movie_model.dart';

class WatchHistory {
  final String id;
  final Movie movie;
  final DateTime watchedAt;
  final int watchedDuration; // Thời gian đã xem (giây)
  final int totalDuration; // Tổng thời gian phim (giây)
  final int episode; // Tập đã xem
  final double progress; // Tiến độ xem (0.0 - 1.0)

  WatchHistory({
    required this.id,
    required this.movie,
    required this.watchedAt,
    this.watchedDuration = 0,
    this.totalDuration = 0,
    this.episode = 1,
    this.progress = 0.0,
  });

  // Tính phần trăm đã xem
  int get progressPercentage => (progress * 100).round();

  // Kiểm tra đã xem xong chưa
  bool get isCompleted => progress >= 0.9;

  // Format thời gian xem
  String get formattedWatchTime {
    final now = DateTime.now();
    final difference = now.difference(watchedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xem';
    }
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movie': {
        'id': movie.id,
        'title': movie.title,
        'englishTitle': movie.englishTitle,
        'posterUrl': movie.posterUrl,
        'backdropUrl': movie.backdropUrl,
        'rating': movie.rating,
        'year': movie.year,
        'ageRestriction': movie.ageRestriction,
        'slug': movie.slug,
        'description': movie.description,
        'horizontalPosters': movie.horizontalPosters,
      },
      'watchedAt': watchedAt.toIso8601String(),
      'watchedDuration': watchedDuration,
      'totalDuration': totalDuration,
      'episode': episode,
      'progress': progress,
    };
  }

  // Create from JSON
  factory WatchHistory.fromJson(Map<String, dynamic> json) {
    return WatchHistory(
      id: json['id'],
      movie: Movie(
        id: json['movie']['id'],
        title: json['movie']['title'],
        slug:
            json['movie']['slug'] ??
            json['movie']['title'].toLowerCase().replaceAll(' ', '-'),
        englishTitle: json['movie']['englishTitle'],
        description: json['movie']['description'] ?? 'Chưa có mô tả.',
        year: json['movie']['year'],
        rating: json['movie']['rating'],
        horizontalPosters:
            json['movie']['horizontalPosters'] ?? json['movie']['posterUrl'],
        posterUrl: json['movie']['posterUrl'],
        backdropUrl: json['movie']['backdropUrl'],
        ageRestriction: json['movie']['ageRestriction'] ?? 'T13',
      ),
      watchedAt: DateTime.parse(json['watchedAt']),
      watchedDuration: json['watchedDuration'] ?? 0,
      totalDuration: json['totalDuration'] ?? 0,
      episode: json['episode'] ?? 1,
      progress: (json['progress'] ?? 0.0).toDouble(),
    );
  }
}
