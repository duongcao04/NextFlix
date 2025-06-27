import 'package:flutter/foundation.dart';

class Episode {
  final int episodeNumber;
  final String embedVideo;

  Episode({required this.episodeNumber, required this.embedVideo});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      episodeNumber: json['episode_number'] ?? 1,
      embedVideo: json['embed_video'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'episode_number': episodeNumber,
    'embed_video': embedVideo,
  };
}

class Movie {
  final String id;
  final String title;
  final String slug;
  final String englishTitle;
  final String description;
  final String year;
  final String rating;
  final String ageRestriction;
  final String resolution;

  final String posterUrl;
  final String horizontalPosters;
  final String backdropUrl;

  final int duration;
  final int season;
  final int episode;

  final String latestEpisode;

  final String releaseDate;
  final int? type;
  final List<Episode> episodes;

  Movie({
    required this.id,
    required this.title,
    required this.slug,
    required this.englishTitle,
    required this.description,
    required this.year,
    required this.rating,
    required this.horizontalPosters,
    required this.posterUrl,
    required this.backdropUrl,
    this.ageRestriction = 'T16',
    this.resolution = '4K',
    this.duration = 0,
    this.season = 1,
    this.episode = 1,
    this.latestEpisode = 'N/A',
    this.releaseDate = '2025-05-18',
    this.type,
    this.episodes = const [],
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final images = json['images'] ?? {};

    final posters = images['posters'] ?? '';
    final backdrops = images['backdrops'] ?? '';
    final horizontalPosters = images['horizontal_posters'] ?? '';

    // Xử lý đường dẫn ảnh – nếu là relative path thì thêm domain
    String normalizeImagePath(String path) {
      if (path.startsWith('http')) return path;
      return 'https://img.ophim.live/uploads/movies/$path';
    }

    debugPrint('Raw seasons data: ${json['seasons']}');

    List<Episode> episodes = [];
    try {
      final seasons = json['seasons'];
      debugPrint('✅ SEASONS: $seasons'); // <-- LOG kiểm tra

      final season0 = seasons?[0];
      if (season0 != null && season0['episodes'] is List) {
        episodes =
            (season0['episodes'] as List)
                .map((e) => Episode.fromJson(Map<String, dynamic>.from(e)))
                .toList();

        debugPrint('✅ PARSED ${episodes.length} episodes');
      } else {
        debugPrint('⚠️ Không có season[0] hoặc episodes không hợp lệ');
      }
    } catch (e) {
      debugPrint('❌ Lỗi khi parse episodes: $e');
    }

    return Movie(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      englishTitle: json['english_title'] ?? '',
      description: json['overview'] ?? 'Chưa có mô tả.',
      year: json['year'] ?? '',
      rating: json['rating'] ?? 'T13',
      slug: json['slug'] ?? '',
      posterUrl:
          posters.isNotEmpty
              ? normalizeImagePath(posters)
              : 'https://via.placeholder.com/300x450.png?text=No+Image',
      horizontalPosters:
          horizontalPosters.isNotEmpty
              ? normalizeImagePath(horizontalPosters)
              : 'https://via.placeholder.com/1280x720.png?text=No+Image',
      backdropUrl:
          backdrops.isNotEmpty
              ? normalizeImagePath(backdrops)
              : 'https://via.placeholder.com/1280x720.png?text=No+Backdrop',
      ageRestriction: json['rating'] ?? 'T16',
      resolution: '4K',
      duration: ((json['cw']?['duration'] ?? 0) as num).round(),
      season: json['latest_season'] ?? 1,
      episode: json['cw']?['episode_number'] ?? 1,
      latestEpisode: 'N/A',
      releaseDate: json['release_date'] ?? "",
      type: json['type'],
      episodes: episodes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'englishTitle': englishTitle,
      'description': description,
      'year': year,
      'rating': rating,
      'ageRestriction': ageRestriction,
      'resolution': resolution,
      'posterUrl': posterUrl,
      'horizontalPosters': horizontalPosters,
      'backdropUrl': backdropUrl,
      'duration': duration,
      'season': season,
      'episode': episode,
      'latestEpisode': latestEpisode,
      'releaseDate': releaseDate,
      'type': type,
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }
}
