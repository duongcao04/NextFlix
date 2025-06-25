import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/watch_history_model.dart';
import '../models/movie_model.dart';

class WatchHistoryService {
  static const String _historyKey = 'watch_history';
  static WatchHistoryService? _instance;
  WatchHistoryService._();
  static WatchHistoryService get instance {
    _instance ??= WatchHistoryService._();
    return _instance!;
  }

  // Lấy danh sách lịch sử
  Future<List<WatchHistory>> getWatchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];
      return historyJson
          .map((json) => WatchHistory.fromJson(jsonDecode(json)))
          .toList()
        ..sort(
          (a, b) => b.watchedAt.compareTo(a.watchedAt),
        ); // Sắp xếp theo thời gian mới nhất
    } catch (e) {
      print('Error loading watch history: $e');
      return [];
    }
  }

  // Thêm phim vào lịch sử

  Future<void> addToHistory(
    Movie movie, {
    int watchedDuration = 0,
    int totalDuration = 0,
    int episode = 1,
    double progress = 0.0,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getWatchHistory();
      // Kiểm tra xem phim đã có trong lịch sử chưa
      final existingIndex = history.indexWhere(
        (item) => item.movie.id == movie.id && item.episode == episode,
      );
      final watchHistory = WatchHistory(
        id: '${movie.id}_${episode}_${DateTime.now().millisecondsSinceEpoch}',
        movie: movie,
        watchedAt: DateTime.now(),
        watchedDuration: watchedDuration,
        totalDuration: totalDuration,
        episode: episode,
        progress: progress,
      );
      if (existingIndex != -1) {
        // Cập nhật lịch sử hiện có
        history[existingIndex] = watchHistory;
      } else {
        // Thêm mới vào đầu danh sách
        history.insert(0, watchHistory);
      }
      // Giới hạn lịch sử tối đa 100 item
      if (history.length > 100) {
        history.removeRange(100, history.length);
      }
      // Lưu vào SharedPreferences

      final historyJson =
          history.map((item) => jsonEncode(item.toJson())).toList();
      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      print('Error adding to watch history: $e');
    }
  }

  // Xóa một item khỏi lịch sử
  Future<void> removeFromHistory(String historyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getWatchHistory();
      history.removeWhere((item) => item.id == historyId);

      final historyJson =
          history.map((item) => jsonEncode(item.toJson())).toList();
      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      print('Error removing from watch history: $e');
    }
  }

  // Xóa nhiều item khỏi lịch sử
  Future<void> removeMultipleFromHistory(List<String> historyIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getWatchHistory();
      history.removeWhere((item) => historyIds.contains(item.id));

      final historyJson =
          history.map((item) => jsonEncode(item.toJson())).toList();
      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      print('Error removing multiple from watch history: $e');
    }
  }

  // Xóa toàn bộ lịch sử
  Future<void> clearAllHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      print('Error clearing watch history: $e');
    }
  }

  // Tìm kiếm trong lịch sử
  Future<List<WatchHistory>> searchHistory(String query) async {
    final history = await getWatchHistory();
    if (query.isEmpty) return history;
    return history.where((item) {
      return item.movie.title.toLowerCase().contains(query.toLowerCase()) ||
          item.movie.englishTitle.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
