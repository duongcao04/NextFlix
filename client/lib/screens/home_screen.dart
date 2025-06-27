import 'package:flutter/material.dart' hide Banner;
import 'package:nextflix/services/movie_service.dart';
import 'package:nextflix/models/movie_model.dart';
import 'package:nextflix/widgets/home/banner.dart';
import 'package:nextflix/widgets/filter_bar_delegate.dart';
import 'package:nextflix/widgets/movie_section.dart';
import 'package:nextflix/widgets/header.dart';
import 'topic_screen.dart';
import 'package:nextflix/models/topic_model.dart';
import 'package:nextflix/services/topic_service.dart';
import 'package:nextflix/screens/genre_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const Header(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: false, delegate: FilterBarDelegate()),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),

                // 🔥 Banner phim nổi bật từ Firestore
                FutureBuilder<List<Movie>>(
                  future: MovieService().fetchFeaturedMovies(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Không có phim nổi bật"),
                      );
                    }
                    return Banner(movies: snapshot.data!);
                  },
                ),

                const SizedBox(height: 24),

                // 🌟 Chủ đề gợi ý
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Bạn đang quan tâm gì?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TopicScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                _buildInterestChips(),
                const SizedBox(height: 24),
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
            ),
          ),
        ],
      ),
    );
  }

  // 🎬 Section phim động từ genre
  Widget _buildSection(String title, String genre) {
    return FutureBuilder<List<Movie>>(
      future: MovieService().fetchMoviesByGenre(genre),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("Không có phim $genre nào."),
          );
        }
        return MovieSection(
          title: title,
          movies: snapshot.data!,
          onMorePressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GenreScreen(genreName: title, genreSlug: genre),
              ),
            );
          },
        );
      },
    );
  }

  // 🎨 Thẻ chủ đề gợi ý
  Widget _buildInterestChips() {
    return FutureBuilder<List<Topic>>(
      future: TopicService().fetchTopics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Không có chủ đề."),
          );
        }
        print("Lỗi nè");
        debugPrint('🎯 Topics loaded: ${snapshot.data?.length}');
        debugPrint('🔥 Raw data: ${snapshot.data}');

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children:
                snapshot.data!.map((topic) => _buildTopicCard(topic)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTopicCard(Topic topic) {
    final color = _hexToColor(topic.color);
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        topic.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }
}
