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

                // 🇰🇷 Phim Hàn Quốc
                _buildSection('Phim Cổ Trang mới', 'co-trang'),

                const SizedBox(height: 24),

                // 🇨🇳 Phim Trung Quốc
                _buildSection('Phim Tình Cảm mới', 'tinh-cam'),

                const SizedBox(height: 32),
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
        return MovieSection(title: title, movies: snapshot.data!);
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
        print('🎯 Topics loaded: ${snapshot.data?.length}');
        print('🔥 Raw data: ${snapshot.data}');

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
