import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class Banner extends StatelessWidget {
  final Movie? movie;

  const Banner({super.key, this.movie});

  String _formatDuration(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    return '${hours}h${remainingMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    if (movie == null) {
      return Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey[800],
        child: const Center(child: Text('Không có phim nổi bật')),
      );
    }

    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(movie!.posterUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie!.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'IMDb ${movie!.rating}  ${movie!.year}  ${_formatDuration(movie!.duration)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
