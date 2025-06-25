import 'package:flutter/material.dart';
import 'package:nextflix/models/movie_model.dart';
import '../widgets/date_selector.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int selectedDateIndex =
      7; // Mặc định là hôm nay (index 7 trong danh sách 7 ngày trước + hôm nay + 30 ngày sau)
  DateTime selectedDate = DateTime.now();

  // Tạo dữ liệu phim ngẫu nhiên cho các ngày
  List<MovieShowtime> _getMoviesForDate(DateTime date) {
    // Tạo seed dựa trên ngày để có dữ liệu nhất quán
    final seed = date.day + date.month * 31;

    final allMovies = [
      Movie(
        id: '1',
        title: 'Ngưu Lang Chức Nữ',
        slug: 'nguu-lang-chuc-nu',
        englishTitle: 'Head Over Heels',
        description: 'Một câu chuyện tình yêu lãng mạn giữa hai thế giới.',
        year: '2025',
        rating: '8.5',
        horizontalPosters: 'https://i.imgur.com/bJ0DFla.jpg',
        posterUrl: 'https://i.imgur.com/bJ0DFla.jpg',
        backdropUrl: 'https://i.imgur.com/bJ0DFla.jpg',
        ageRestriction: 'T13',
        episode: 1,
        latestEpisode: '1',
      ),
      Movie(
        id: '2',
        title: 'Thợ Săn Dao Mổ',
        slug: 'tho-san-dao-mo',
        englishTitle: 'Hunter with a Scalpel',
        description: 'Câu chuyện về một bác sĩ phẫu thuật bí ẩn.',
        year: '2025',
        rating: '9.0',
        horizontalPosters: 'https://i.imgur.com/VFyzjGz.jpg',
        posterUrl: 'https://i.imgur.com/VFyzjGz.jpg',
        backdropUrl: 'https://i.imgur.com/VFyzjGz.jpg',
        ageRestriction: 'T18',
        episode: 6,
        latestEpisode: '6',
      ),
      Movie(
        id: '3',
        title: 'Bảy Di Vật Tà Ám',
        slug: 'bay-di-vat-ta-am',
        englishTitle: 'The Seven Relics of ill Omen',
        description: 'Cuộc phiêu lưu tìm kiếm bảy di vật bí ẩn.',
        year: '2025',
        rating: '8.8',
        horizontalPosters: 'https://i.imgur.com/JPRFgBe.jpg',
        posterUrl: 'https://i.imgur.com/JPRFgBe.jpg',
        backdropUrl: 'https://i.imgur.com/JPRFgBe.jpg',
        ageRestriction: 'T13',
        episode: 29,
        latestEpisode: '29',
      ),
      Movie(
        id: '4',
        title: 'Ma Thổi Đèn',
        slug: 'ma-thoi-den',
        englishTitle: 'Ghost Blows Out the Light',
        description: 'Cuộc phiêu lưu khám phá những ngôi mộ cổ bí ẩn.',
        year: '2025',
        rating: '8.7',
        horizontalPosters:
            'https://via.placeholder.com/300x450/FF6B6B/FFFFFF?text=Ma+Thoi+Den',
        posterUrl:
            'https://via.placeholder.com/300x450/FF6B6B/FFFFFF?text=Ma+Thoi+Den',
        backdropUrl:
            'https://via.placeholder.com/300x450/FF6B6B/FFFFFF?text=Ma+Thoi+Den',
        ageRestriction: 'T16',
        episode: 12,
        latestEpisode: '12',
      ),
    ];

    // Tạo lịch chiếu khác nhau cho mỗi ngày
    final movieCount = (seed % 3) + 1; // 1-3 phim mỗi ngày
    final selectedMovies = <MovieShowtime>[];

    for (int i = 0; i < movieCount; i++) {
      final movie = allMovies[(seed + i) % allMovies.length];
      final showtimes = _generateShowtimes(seed + i);
      selectedMovies.add(MovieShowtime(movie: movie, showtimes: showtimes));
    }

    return selectedMovies;
  }

  List<String> _generateShowtimes(int seed) {
    final baseShowtimes = [
      '09:00',
      '11:30',
      '14:00',
      '16:30',
      '19:00',
      '21:30',
    ];
    final count = (seed % 4) + 2; // 2-5 suất chiếu
    return baseShowtimes.take(count).toList();
  }

  String _formatSelectedDate(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);

    if (compareDate.isAtSameMomentAs(today)) {
      return 'Hôm nay';
    } else if (compareDate.isAtSameMomentAs(
      today.add(const Duration(days: 1)),
    )) {
      return 'Ngày mai';
    } else if (compareDate.isAtSameMomentAs(
      today.subtract(const Duration(days: 1)),
    )) {
      return 'Hôm qua';
    } else if (compareDate.isBefore(today)) {
      const weekdays = [
        'Thứ 2',
        'Thứ 3',
        'Thứ 4',
        'Thứ 5',
        'Thứ 6',
        'Thứ 7',
        'Chủ nhật',
      ];
      return '${weekdays[date.weekday - 1]}, ${date.day}/${date.month} (Đã qua)';
    } else {
      const weekdays = [
        'Thứ 2',
        'Thứ 3',
        'Thứ 4',
        'Thứ 5',
        'Thứ 6',
        'Thứ 7',
        'Chủ nhật',
      ];
      return '${weekdays[date.weekday - 1]}, ${date.day}/${date.month}';
    }
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

// Model cho lịch chiếu phim
class MovieShowtime {
  final Movie movie;
  final List<String> showtimes;

  MovieShowtime({required this.movie, required this.showtimes});
}

// Widget hiển thị phim với giờ chiếu
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
    return Container(
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
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[700],
                      child: const Icon(Icons.movie, color: Colors.white),
                    );
                  },
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
                        const Icon(Icons.star, size: 12, color: Colors.yellow),
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
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Đã chọn suất chiếu $time - ${movieShowtime.movie.title}',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
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
    );
  }
}
