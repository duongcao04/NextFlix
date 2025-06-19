import 'package:flutter/material.dart';
import 'package:nextflix/models/movie_model.dart';
import 'package:nextflix/services/movie_service.dart';
import 'package:nextflix/widgets/movie_card.dart';

class GenreScreen extends StatelessWidget {
  final String genreName;
  final String genreSlug;

  const GenreScreen({super.key, required this.genreName, required this.genreSlug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(genreName),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Movie>>(
        future: MovieService().fetchMoviesByGenre(genreSlug),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có phim", style: TextStyle(color: Colors.white)));
          }

          final movies = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: movies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return MovieCard(movie: movies[index]);
            },
          );
        },
      ),
    );
  }
}
