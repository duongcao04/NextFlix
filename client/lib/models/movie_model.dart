class Movie {
  final String title;
  final String posterUrl;
  final String year;
  final String rating;
  final String latestEpisode;
  final int duration;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.year,
    required this.rating,
    this.latestEpisode = 'N/A',
    this.duration = 0,
  });
}