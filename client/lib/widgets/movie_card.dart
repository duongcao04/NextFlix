import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../screens/movie_detail_screen.dart';
import '../widgets/favorite_button.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool showFavoriteButton;

  const MovieCard({
    super.key,
    required this.movie,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('👉 Tapped movie: ${movie.title}, ID: ${movie.id}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailScreen(movieId: movie.id),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.backdropUrl,
                    height: 150,
                    width: 120,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          height: 150,
                          width: 120,
                          color: Colors.grey,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.white,
                          ),
                        ),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 150,
                        width: 120,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    color: Colors.black54,
                    child: Text(
                      movie.latestEpisode != 'N/A'
                          ? 'Tập ${movie.latestEpisode}'
                          : 'N/A',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
                // ❤️ Nút yêu thích
                if (showFavoriteButton)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FavoriteButton(
                        movie: movie,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(Icons.star, size: 12, color: Colors.red),
                const SizedBox(width: 4),
                Text(
                  movie.rating,
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
