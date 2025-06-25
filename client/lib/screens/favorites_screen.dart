import 'package:flutter/material.dart';
import 'package:nextflix/screens/actor_detail_screen.dart';
import '../models/favorite_model.dart';
import '../services/favorite_service.dart';
import '../screens/movie_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Favorite> _allFavorites = [];
  List<Favorite> _movieFavorites = [];
  List<Favorite> _actorFavorites = [];
  List<Favorite> _filteredFavorites = [];
  final Set<String> _selectedItems = {};
  bool _isSelectionMode = false;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadFavorites();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadFavorites() async {
    setState(() => _isLoading = true);

    final allFavorites = await FavoriteService.instance.getFavorites();
    final movieFavorites = await FavoriteService.instance.getFavoriteMovies();
    final actorFavorites = await FavoriteService.instance.getFavoriteActors();

    setState(() {
      _allFavorites = allFavorites;
      _movieFavorites = movieFavorites;
      _actorFavorites = actorFavorites;
      _updateFilteredList();
      _isLoading = false;
    });
  }

  void _onTabChanged() {
    _updateFilteredList();
    setState(() {
      _selectedItems.clear();
      _isSelectionMode = false;
    });
  }

  void _updateFilteredList() {
    List<Favorite> sourceList;
    switch (_tabController.index) {
      case 0:
        sourceList = _allFavorites;
        break;
      case 1:
        sourceList = _movieFavorites;
        break;
      case 2:
        sourceList = _actorFavorites;
        break;
      default:
        sourceList = _allFavorites;
    }

    final query = _searchController.text;
    if (query.isEmpty) {
      _filteredFavorites = sourceList;
    } else {
      _filteredFavorites =
          sourceList.where((item) {
            return item.title.toLowerCase().contains(query.toLowerCase()) ||
                item.subtitle.toLowerCase().contains(query.toLowerCase());
          }).toList();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _updateFilteredList();
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
              'Xóa khỏi yêu thích',
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
      await FavoriteService.instance.removeMultipleFromFavorites(
        _selectedItems.toList(),
      );
      _loadFavorites();
      _toggleSelectionMode();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa ${_selectedItems.length} mục khỏi yêu thích'),
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
                  'Yêu thích',
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
              onPressed:
                  _filteredFavorites.isNotEmpty ? _toggleSelectionMode : null,
              icon: const Icon(Icons.checklist, color: Colors.white),
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Phim'),
            Tab(text: 'Diễn viên'),
          ],
        ),
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
                hintText: 'Tìm kiếm trong yêu thích...',
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
                    : _filteredFavorites.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredFavorites.length,
                      itemBuilder: (context, index) {
                        final item = _filteredFavorites[index];
                        return _buildFavoriteItem(item);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    String subtitle;
    IconData icon;

    if (_searchController.text.isNotEmpty) {
      message = 'Không tìm thấy kết quả nào';
      subtitle = 'Thử tìm kiếm với từ khóa khác';
      icon = Icons.search_off;
    } else {
      switch (_tabController.index) {
        case 1:
          message = 'Chưa có phim yêu thích';
          subtitle = 'Các phim bạn yêu thích sẽ xuất hiện ở đây';
          icon = Icons.movie_outlined;
          break;
        case 2:
          message = 'Chưa có diễn viên yêu thích';
          subtitle = 'Các diễn viên bạn yêu thích sẽ xuất hiện ở đây';
          icon = Icons.person_outline;
          break;
        default:
          message = 'Chưa có mục yêu thích';
          subtitle = 'Thêm phim và diễn viên vào danh sách yêu thích';
          icon = Icons.favorite_outline;
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(Favorite item) {
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
            _navigateToDetail(item);
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

              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl,
                  width: 60,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 90,
                      color: Colors.grey[700],
                      child: Icon(
                        item.type == FavoriteType.movie
                            ? Icons.movie
                            : Icons.person,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                item.type == FavoriteType.movie
                                    ? Colors.blue
                                    : Colors.purple,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.type == FavoriteType.movie
                                ? 'Phim'
                                : 'Diễn viên',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (item.subtitle.isNotEmpty)
                      Text(
                        item.subtitle,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),

                    // Additional info
                    Row(
                      children: [
                        if (item.year.isNotEmpty) ...[
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.year,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatAddedTime(item.addedAt),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
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
                      await FavoriteService.instance.removeFromFavorites(
                        item.id,
                      );
                      _loadFavorites();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã xóa khỏi yêu thích'),
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
                              Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Bỏ yêu thích',
                                style: TextStyle(color: Colors.red),
                              ),
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

  void _navigateToDetail(Favorite item) {
    if (item.type == FavoriteType.movie && item.movie != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MovieDetailScreen(movieId: item.movie!.id),
        ),
      );
    } else if (item.type == FavoriteType.actor && item.actor != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ActorDetailScreen(actor: item.actor!),
        ),
      );
    }
  }

  String _formatAddedTime(DateTime addedAt) {
    final now = DateTime.now();
    final difference = now.difference(addedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa thêm';
    }
  }
}
