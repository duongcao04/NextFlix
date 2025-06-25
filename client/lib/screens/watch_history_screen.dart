import 'package:flutter/material.dart';
import '../models/watch_history_model.dart';
import '../services/watch_history_service.dart';
import '../screens/movie_detail_screen.dart';

class WatchHistoryScreen extends StatefulWidget {
  const WatchHistoryScreen({super.key});

  @override
  State<WatchHistoryScreen> createState() => _WatchHistoryScreenState();
}

class _WatchHistoryScreenState extends State<WatchHistoryScreen> {
  List<WatchHistory> _history = [];
  List<WatchHistory> _filteredHistory = [];
  final Set<String> _selectedItems = {};
  bool _isSelectionMode = false;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadHistory() async {
    setState(() => _isLoading = true);

    final history = await WatchHistoryService.instance.getWatchHistory();

    setState(() {
      _history = history;
      _filteredHistory = history;
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      if (query.isEmpty) {
        _filteredHistory = _history;
      } else {
        _filteredHistory =
            _history.where((item) {
              return item.movie.title.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  item.movie.englishTitle.toLowerCase().contains(
                    query.toLowerCase(),
                  );
            }).toList();
      }
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedItems.clear();
      }
    });
  }

  void _toggleItemSelection(String itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
    });
  }

  void _deleteSelectedItems() async {
    if (_selectedItems.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text(
              'Xóa lịch sử',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Bạn có chắc chắn muốn xóa ${_selectedItems.length} mục đã chọn?',
              style: const TextStyle(color: Colors.grey),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await WatchHistoryService.instance.removeMultipleFromHistory(
        _selectedItems.toList(),
      );
      _loadHistory();
      _toggleSelectionMode();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa ${_selectedItems.length} mục khỏi lịch sử'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _clearAllHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text(
              'Xóa toàn bộ lịch sử',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Bạn có chắc chắn muốn xóa toàn bộ lịch sử xem? Hành động này không thể hoàn tác.',
              style: TextStyle(color: Colors.grey),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Xóa tất cả',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await WatchHistoryService.instance.clearAllHistory();
      _loadHistory();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa toàn bộ lịch sử xem'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title:
            _isSelectionMode
                ? Text(
                  '${_selectedItems.length} đã chọn',
                  style: const TextStyle(color: Colors.white),
                )
                : const Text(
                  'Lịch sử xem',
                  style: TextStyle(color: Colors.white),
                ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              onPressed:
                  _selectedItems.isNotEmpty ? _deleteSelectedItems : null,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
            IconButton(
              onPressed: _toggleSelectionMode,

              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ] else ...[
            IconButton(
              onPressed: _history.isNotEmpty ? _toggleSelectionMode : null,
              icon: const Icon(Icons.checklist, color: Colors.white),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: const Color(0xFF1E1E1E),
              onSelected: (value) {
                if (value == 'clear_all') {
                  _clearAllHistory();
                }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'clear_all',
                      child: Row(
                        children: [
                          Icon(Icons.clear_all, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Xóa tất cả',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm trong lịch sử...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child:
                _isLoading
                    ? const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    )
                    : _filteredHistory.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredHistory.length,
                      itemBuilder: (context, index) {
                        final item = _filteredHistory[index];
                        return _buildHistoryItem(item);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchController.text.isNotEmpty
                ? Icons.search_off
                : Icons.history,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty
                ? 'Không tìm thấy kết quả nào'
                : 'Chưa có lịch sử xem',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty
                ? 'Thử tìm kiếm với từ khóa khác'
                : 'Các phim bạn đã xem sẽ xuất hiện ở đây',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(WatchHistory item) {
    final isSelected = _selectedItems.contains(item.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
            isSelected ? Colors.red.withOpacity(0.1) : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: Colors.red, width: 1) : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (_isSelectionMode) {
            _toggleItemSelection(item.id);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(movieId: item.movie.id),
              ),
            );
          }
        },
        onLongPress: () {
          if (!_isSelectionMode) {
            _toggleSelectionMode();
            _toggleItemSelection(item.id);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Selection checkbox
              if (_isSelectionMode)
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isSelected ? Colors.red : Colors.grey[400],
                  ),
                ),

              // Movie poster
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.movie.posterUrl,
                  width: 60,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 90,
                      color: Colors.grey[700],
                      child: const Icon(Icons.movie, color: Colors.white),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              // Movie info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.movie.englishTitle,
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Episode and progress
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Tập ${item.episode}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (item.progress > 0)
                          Text(
                            '${item.progressPercentage}%',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        if (item.isCompleted)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Watch time
                    Text(
                      item.formattedWatchTime,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),

                    // Progress bar
                    if (item.progress > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: item.progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Action button
              if (!_isSelectionMode)
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[400]),
                  color: const Color(0xFF2A2A2A),
                  onSelected: (value) async {
                    if (value == 'delete') {
                      await WatchHistoryService.instance.removeFromHistory(
                        item.id,
                      );
                      _loadHistory();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã xóa khỏi lịch sử'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text('Xóa', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
