import 'package:flutter/material.dart';
import 'package:nextflix/models/movie_model.dart';
import 'package:nextflix/services/movie_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Movie? movie;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovie();
  }

  Future<void> fetchMovie() async {
    final result = await MovieService().fetchMovieById(widget.movieId);
    if (result != null) {
      setState(() {
        movie = result;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
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
            children: [_buildBanner(), _buildDetails()],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Stack(
      children: [
        // 📸 Full backdrop image (dưới cùng)
        Image.network(
          movie!.backdropUrl,
          width: double.infinity,
          height: 250, // hoặc MediaQuery.of(context).size.width * 0.6
          fit: BoxFit.cover,
        ),

        // 📍 Overlay nội dung
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
              // Text(
              //   movie!.title,
              //   style: const TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Chuyển đến trang player
                },
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
          const SizedBox(height: 12),
          if (movie!.latestEpisode != 'N/A')
            Text(
              "Tập mới nhất: ${movie!.latestEpisode}",
              style: const TextStyle(color: Colors.white70),
            ),
        ],
      ),
    );
  }
}
