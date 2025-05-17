class Movie {
  final String title;
  final String posterUrl;
  final String year;
  final String rating;
  final String latestEpisode;
  final int duration;

  //  Thêm các trường mới
  final String englishTitle;
  final String description;
  final String resolution;
  final String ageRestriction;
  final int season;
  final int episode;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.year,
    required this.rating,
    this.latestEpisode = 'N/A',
    this.duration = 0,
    this.englishTitle = 'Unknown',
    this.description = 'Chưa có mô tả.',
    this.resolution = '4K',
    this.ageRestriction = 'T16',
    this.season = 1,
    this.episode = 1,
  });
}
