import 'package:flutter/material.dart';
import 'package:nextflix/models/movie_model.dart';
import 'package:nextflix/services/movie_service.dart';
import '../widgets/date_selector.dart';
import 'movie_detail_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int selectedDateIndex = 7;
  DateTime selectedDate = DateTime.now();
  List<Movie> allMovies = [];
  final List<String> fixedShowtimes = [
    '09:00',
    '11:30',
    '14:00',
    '16:30',
    '19:00',
    '21:30',
  ];

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    final movies = await MovieService().fetchAllMovies();
    setState(() {
      allMovies = movies;
    });
  }

  List<MovieShowtime> _getMoviesForDate(DateTime date) {
    if (allMovies.isEmpty) return [];

    final seed = date.day + date.month * 31;
    final movieCount = (seed % 3) + 1;
    final selectedMovies = <MovieShowtime>[];

    for (int i = 0; i < movieCount; i++) {
      final movie = allMovies[(seed + i) % allMovies.length];
      selectedMovies.add(
        MovieShowtime(movie: movie, showtimes: fixedShowtimes),
      );
    }

    return selectedMovies;
  }

  String _formatSelectedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);

    if (compareDate == today) return 'Hôm nay';
    if (compareDate == today.add(const Duration(days: 1))) return 'Ngày mai';
    if (compareDate == today.subtract(const Duration(days: 1)))
      return 'Hôm qua';

    const weekdays = [
      'Thứ 2',
      'Thứ 3',
      'Thứ 4',
      'Thứ 5',
      'Thứ 6',
      'Thứ 7',
      'Chủ nhật',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day}/${date.month}' +
        (compareDate.isBefore(today) ? ' (Đã qua)' : '');
  }

  @override
  Widget build(BuildContext context) {
    final currentMovies = _getMoviesForDate(selectedDate);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lịch chiếu',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              _formatSelectedDate(selectedDate),
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          DateSelector(
            selectedIndex: selectedDateIndex,
            onTap: (index, date) {
              setState(() {
                selectedDateIndex = index;
                selectedDate = date;
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child:
                currentMovies.isEmpty
                    ? const Center(
                      child: Text(
                        'Không có suất chiếu nào trong ngày này',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: currentMovies.length,
                      itemBuilder:
                          (_, i) => MovieScheduleCard(
                            movieShowtime: currentMovies[i],
                            selectedDate: selectedDate,
                          ),
                    ),
          ),
        ],
      ),
    );
  }
}

class MovieShowtime {
  final Movie movie;
  final List<String> showtimes;

  MovieShowtime({required this.movie, required this.showtimes});
}

class MovieScheduleCard extends StatelessWidget {
  final MovieShowtime movieShowtime;
  final DateTime selectedDate;

  const MovieScheduleCard({
    super.key,
    required this.movieShowtime,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => MovieDetailScreen(movieId: movieShowtime.movie.id),
            ),
          ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movieShowtime.movie.posterUrl,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          width: 80,
                          height: 120,
                          color: Colors.grey[700],
                          child: const Icon(Icons.movie, color: Colors.white),
                        ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movieShowtime.movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        movieShowtime.movie.englishTitle,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              movieShowtime.movie.ageRestriction,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tập ${movieShowtime.movie.latestEpisode}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            movieShowtime.movie.rating,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Giờ chiếu:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  movieShowtime.showtimes.map((time) {
                    return GestureDetector(
                      onTap:
                          () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Đã chọn suất chiếu $time - ${movieShowtime.movie.title}',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          time,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
