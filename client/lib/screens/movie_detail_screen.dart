import 'package:flutter/material.dart';
import 'package:nextflix/models/movie_model.dart';
import 'package:nextflix/services/movie_service.dart';
import 'package:nextflix/screens/player_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Movie? movie;
  bool isLoading = true;
  final GlobalKey _episodeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    fetchMovie();
  }

  Future<void> fetchMovie() async {
    final result = await MovieService().fetchMovieById(widget.movieId);
    setState(() {
      movie = result;
      isLoading = false;
    });
    print('Số tập phim: ${movie?.episodes.length}');
  }

  void _scrollToEpisodes() {
    final context = _episodeKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (movie == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Không tìm thấy phim",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBanner(),
              _buildDetails(),
              if (movie!.episodes.isNotEmpty) _buildEpisodeList(),
            ],
          ),
        ),
      ),
    );
  }

  /// 🖼 Banner phim + nút Xem phim
  Widget _buildBanner() {
    return Stack(
      children: [
        Image.network(
          movie!.backdropUrl,
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
        ),
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                movie!.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _scrollToEpisodes,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Xem phim'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 📄 Hiển thị mô tả và metadata phim
  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Thông tin phim',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            movie!.description,
            style: const TextStyle(color: Colors.white, height: 1.5),
          ),
          const SizedBox(height: 24),

          if (movie!.latestEpisode != 'N/A') ...[
            const SizedBox(height: 8),
            Text(
              "Tập mới nhất: ${movie!.latestEpisode}",
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ],
      ),
    );
  }

  /// 🎞 Danh sách các tập phim
  Widget _buildEpisodeList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Danh sách tập',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Grid 5 cột
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.2, // tỉ lệ ngang/dọc cho ô
            children:
                movie!.episodes.map((episode) {
                  return GestureDetector(
                    onTap: () {
                      print("Xem tập ${episode.episodeNumber}");

                      // TODO: Chuyển sang trang Player, truyền link video hoặc dữ liệu tập
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => VideoPlayerScreen(
                                videoUrl: episode.embedVideo,
                                title:
                                    '${movie!.title} - Tập ${episode.episodeNumber}',
                              ),
                        ),
                      );
                    },

                    child: Container(
                      alignment: Alignment.center,

                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),

                      child: Text(
                        'Tập ${episode.episodeNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16, // ✅ Tăng cỡ chữ
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),

          const SizedBox(height: 24),
          Text(
            "Năm: ${movie!.year}",
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            "Loại: ${movie!.type == 2 ? 'Phim bộ' : 'Phim lẻ'}",
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            "Đánh giá: ${movie!.rating}",
            style: const TextStyle(color: Colors.white70),
          ),
          if (movie!.latestEpisode != 'N/A') ...[
            const SizedBox(height: 8),
            Text(
              "Tập mới nhất: ${movie!.latestEpisode}",
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ],
      ),
    );
  }
}
