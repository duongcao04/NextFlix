import 'package:flutter/material.dart';
import 'package:nextflix/models/movie_model.dart';
import 'package:nextflix/screens/movie_detail_screen.dart';

class Banner extends StatefulWidget {
  final List<Movie> movies;
  const Banner({super.key, required this.movies});

  @override
  State<Banner> createState() => _BannerState();
}

class _BannerState extends State<Banner> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox.shrink();
    final movie = widget.movies[_currentIndex];

    return Column(
      children: [
        // --- Banner carousel ---
        SizedBox(
          height: 500,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.movies.length,
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              final offset =
                  (_pageController.page ?? _currentIndex.toDouble()) - index;
              final scale = (1 - (offset.abs() * 0.2)).clamp(0.85, 1.0);
              final tilt = offset * 0.04;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailScreen(movieId: movie.id),
                    ),
                  );
                },
                child: Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(tilt)
                        ..scale(scale),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      movie.posterUrl,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      loadingBuilder:
                          (_, child, loading) =>
                              loading == null
                                  ? child
                                  : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      errorBuilder:
                          (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 48),
                    ),
                  ),
                ),
              );
            },
            onPageChanged: (index) => setState(() => _currentIndex = index),
          ),
        ),

        const SizedBox(height: 16),

        // --- Movie titles ---
        Text(
          movie.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          movie.englishTitle,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        // --- Action buttons ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // TODO: chuyển sang trang xem phim
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Xem phim"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailScreen(movieId: movie.id),
                  ),
                );
              },
              icon: const Icon(Icons.info_outline),
              label: const Text("Thông tin"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // --- Movie tags ---
        Wrap(
          spacing: 8,
          children: [
            _buildTag("IMDb ${movie.rating}", Colors.amber[700]!),
            _buildTag(movie.ageRestriction, Colors.grey[800]!),
            _buildTag(movie.year, Colors.grey[800]!),
          ],
        ),

        const SizedBox(height: 16),

        // --- Dots indicator ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.movies.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentIndex == index ? 14 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: _currentIndex == index ? Colors.white : Colors.grey,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}
