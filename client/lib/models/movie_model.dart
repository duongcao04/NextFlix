class Movie {
  final String id;
  final String title;
  final String englishTitle;
  final String description;
  final String year;
  final String rating;
  final String posterUrl;
  final String backdropUrl;
  final String ageRestriction;
  final String resolution;

  final int duration;
  final int season;
  final int episode;
  final String latestEpisode;

  Movie({
    required this.id,
    required this.title,
    required this.englishTitle,
    required this.description,
    required this.year,
    required this.rating,
    required this.posterUrl,
    required this.backdropUrl,
    this.ageRestriction = 'T16',
    this.resolution = '4K',
    this.duration = 0,
    this.season = 1,
    this.episode = 1,
    this.latestEpisode = 'N/A',
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final slug = json['slug'] ?? '';
    final images = json['images'] ?? {};

    final posters = images['posters'] as List<dynamic>? ?? [];
    final backdrops = images['backdrops'] as List<dynamic>? ?? [];

    final posterPath =
        (posters.isNotEmpty && posters.first['path'] != null)
            ? posters.first['path'] as String
            : '';

    final backdropPath =
        (backdrops.isNotEmpty && backdrops.first['path'] != null)
            ? backdrops.first['path'] as String
            : '';

    // Xử lý đường dẫn ảnh – nếu là relative path thì thêm domain
    String normalizeImagePath(String path) {
      if (path.startsWith('http')) return path;
      return 'https://img.ophim.live/uploads/movies/$path';
    }

    return Movie(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      englishTitle: json['english_title'] ?? '',
      description: json['overview'] ?? 'Chưa có mô tả.',
      year: json['year'] ?? '',
      rating: json['rating'] ?? 'T13',
      posterUrl:
          posterPath.isNotEmpty
              ? normalizeImagePath(posterPath)
              : 'https://via.placeholder.com/300x450.png?text=No+Image',
      backdropUrl:
          backdropPath.isNotEmpty
              ? normalizeImagePath(backdropPath)
              : 'https://via.placeholder.com/1280x720.png?text=No+Backdrop',
      ageRestriction: json['rating'] ?? 'T16',
      resolution: '4K',
      duration: ((json['cw']?['duration'] ?? 0) as num).round(),
      season: json['latest_season'] ?? 1,
      episode: json['cw']?['episode_number'] ?? 1,
      latestEpisode: 'N/A',
    );
  }
}
