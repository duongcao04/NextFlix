import 'package:flutter/material.dart';
import 'package:nextflix/models/movie_model.dart';
import 'package:nextflix/models/topic_model.dart';
import 'package:nextflix/screens/movie_detail_screen.dart';
import 'package:nextflix/services/movie_service.dart';
import 'package:nextflix/services/topic_service.dart';
import 'package:nextflix/widgets/movie_section.dart';
import 'package:nextflix/widgets/home/banner.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _results = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results.clear();
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final movies = await MovieService().searchMovies(query);
    setState(() {
      _results = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            const Icon(Icons.search, color: Colors.white54),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm phim...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
                onSubmitted: _onSearchChanged,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: _isSearching ? _buildSearchResults() : _buildDefaultContent(),
    );
  }

  /// Giao diện khi đang tìm kiếm
  Widget _buildSearchResults() {
    if (_results.isEmpty) {
      return const Center(
        child: Text(
          'Không tìm thấy phim nào',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 8,
        childAspectRatio: 0.6,
      ),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final movie = _results[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(movieId: movie.id),
              ),
            );
          },
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 2 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          color: Colors.grey,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.white,
                          ),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  movie.title,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Giao diện mặc định: giống HomeScreen
  Widget _buildDefaultContent() {
    return ListView(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const SizedBox(height: 12),
              const Expanded(
                child: Text(
                  'Phim được tìm kiếm nhiều',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        _buildSection('👑 Hoàng Cung', 'hoang-cung'),
        const SizedBox(height: 20),

        _buildSection('🎭 Chính Kịch', 'chinh-kich'),
        const SizedBox(height: 20),

        _buildSection('💥 Hành Động', 'hanh-dong'),
        const SizedBox(height: 20),

        _buildSection('💕 Tình Cảm', 'tinh-cam'),
        const SizedBox(height: 20),

        _buildSection('🏮 Cổ Trang', 'co-trang'),
        const SizedBox(height: 20),

        _buildSection('⚔️ Chiến Tranh', 'chien-tranh'),
        const SizedBox(height: 20),

        _buildSection('🔬 Khoa Học', 'khoa-hoc'),
        const SizedBox(height: 20),

        _buildSection('🔍 Bí Ẩn', 'bi-an'),
        const SizedBox(height: 20),

        _buildSection('😄 Hài', 'hai'),
        const SizedBox(height: 20),

        _buildSection('🧠 Tâm Lý', 'tam-ly'),
        const SizedBox(height: 20),

        _buildSection('🌟 Kỳ Ảo', 'ky-ao'),
        const SizedBox(height: 20),

        _buildSection('📜 Lịch Sử', 'lich-su'),
        const SizedBox(height: 20),

        _buildSection('💖 Lãng Mạn', 'lang-man'),
        const SizedBox(height: 20),

        _buildSection('🚀 Viễn Tưởng', 'vien-tuong'),
        const SizedBox(height: 20),

        _buildSection('📚 Chuyển Thể', 'chuyen-the'),
        const SizedBox(height: 20),

        _buildSection('🗺️ Phiêu Lưu', 'phieu-luu'),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSection(String title, String genre) {
    return FutureBuilder<List<Movie>>(
      future: MovieService().fetchMoviesByGenre(genre),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }
        return MovieSection(title: title, movies: snapshot.data!);
      },
    );
  }
}
