import 'package:flutter/material.dart' hide Banner;
import 'package:nextflix/widgets/header.dart';
import '../data/mock_data.dart';
import '../widgets/home/banner.dart';
import '../widgets/filter_bar_delegate.dart';
import '../widgets/movie_section.dart';
import '../widgets/footer.dart';
import 'topic_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Header(),
      body: CustomScrollView(
        slivers: [
          // 🔻 Thanh lọc thông minh
          SliverPersistentHeader(pinned: false, delegate: FilterBarDelegate()),

          // 🔻 Nội dung chính
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🎬 Banner nổi bật
                Banner(
                  movies: [
                    MockData.featuredMovie,
                    ...MockData.koreanMovies,
                    ...MockData.chineseMovies,
                  ],
                ),

                const SizedBox(height: 24),

                // 🌟 "Bạn đang quan tâm gì?"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                                MaterialPageRoute(
                                  builder: (_) => TopicScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildInterestCard('Marvel'),
                            _buildInterestCard('Keo Lỳ Slayyy'),
                            _buildInterestCard('Sitcom'),
                            _buildInterestCard('4K'),
                            _buildInterestCard('Lồng Tiếng Cực Mạnh'),
                            _buildInterestCard('Đỉnh Nóc'),
                            _buildInterestCard('Xuyên Không'),
                            _buildInterestCard('Cổ Trang'),
                            _buildInterestCard('9x'),
                            _buildInterestCard('Tham Vọng'),
                            _buildInterestCard('Chữa Lành'),
                            _buildInterestCard('Phù Thủy'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 📺 Mục phim Hàn
                MovieSection(
                  title: 'Phim Hàn Quốc mới',
                  movies: MockData.koreanMovies,
                ),

                const SizedBox(height: 24),

                // 📺 Mục phim Trung
                MovieSection(
                  title: 'Phim Trung Quốc mới',
                  movies: MockData.chineseMovies,
                ),

                const SizedBox(height: 32),

                // 👣 Chân trang
                const FooterWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🎨 Thẻ chủ đề gradient
  static Widget _buildInterestCard(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFf857a6), Color(0xFFFF5858)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
