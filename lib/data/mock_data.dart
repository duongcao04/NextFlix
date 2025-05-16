import '../models/movie_model.dart';

class MockData {
  static final Movie featuredMovie = Movie(
    title: 'Đấu Xử Đường Lối',
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BMDBmYTZjNjUtN2M1MS00MTQ2LTk2ODgtNzc2M2QyZGE5NTVjXkEyXkFqcGdeQXVyNzAwMjU2MTY@._V1_.jpg', // Poster của "The Roundup: No Way Out" (2023)
    year: '2023',
    rating: '8.6',
    duration: 106,
  );

  static final List<Movie> koreanMovies = [
    Movie(
      title: 'Kế Hoạch Của Quỷ Dữ',
      posterUrl:
          'https://static.nutscdn.com/vimg/300-0/0e41b84c4ec0372b4c12409b6e742f1e.jpg',
      year: '2023',
      rating: '8.6',
      latestEpisode: '4',
    ),
    Movie(
      title: 'Bảo Hiểm Ly Hôn',
      posterUrl:
          'https://static.nutscdn.com/vimg/300-0/6591ac85c0e2c6475caeb282fba760b4.jpg',
      year: '2023',
      rating: '8.8',
      latestEpisode: '12',
    ),
  ];

  static final List<Movie> chineseMovies = [
    Movie(
      title: 'Mùa Hoa Rơi Gặp Lại Chàng',
      posterUrl:
          'https://static.nutscdn.com/vimg/300-0/895d462310c51c4a9c33b870795ce7d7.jpg',
      year: '2023',
      rating: '8.5',
      latestEpisode: '10',
    ),
    Movie(
      title: 'Hoài Thủy Trúc Đình',
      posterUrl:
          'https://static.nutscdn.com/vimg/300-0/4e520866d404c1eb9d13c0ca8a6f2198.jpg',
      year: '2023',
      rating: '8.7',
      latestEpisode: '8',
    ),
  ];
}
