import 'package:flutter/material.dart' hide Banner;
import 'package:nextflix/routes/routes.dart';
import '../data/mock_data.dart';
import '../widgets/banner.dart';
import '../widgets/filter_buttons.dart';
import '../widgets/movie_section.dart';
import '../widgets/app_drawer.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import 'package:nextflix/widgets/bottom_app_bar.dart' as custom;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      drawer: const AppDrawer(),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height -
              kToolbarHeight -
              MediaQuery.of(context).padding.top,
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Banner(movie: MockData.featuredMovie),
              const FilterButtons(),
              MovieSection(
                title: 'Phim Hàn Quốc mới',
                movies: MockData.koreanMovies,
              ),
              MovieSection(
                title: 'Phim Trung Quốc mới',
                movies: MockData.chineseMovies,
              ),
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
