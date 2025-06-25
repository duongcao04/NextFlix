import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../models/favorite_model.dart';
import '../services/favorite_service.dart';

class FavoriteButton extends StatefulWidget {
  final Movie? movie;
  final Actor? actor;
  final double size;
  final Color? color;

  const FavoriteButton({
    super.key,
    this.movie,
    this.actor,
    this.size = 24,
    this.color,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() async {
    if (widget.movie != null) {
      final isFavorite = await FavoriteService.instance.isMovieFavorite(
        widget.movie!.id,
      );
      setState(() => _isFavorite = isFavorite);
    } else if (widget.actor != null) {
      final isFavorite = await FavoriteService.instance.isActorFavorite(
        widget.actor!.id,
      );
      setState(() => _isFavorite = isFavorite);
    }
  }

  void _toggleFavorite() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (_isFavorite) {
        // Remove from favorites
        final favorites = await FavoriteService.instance.getFavorites();
        final favoriteToRemove = favorites.firstWhere(
          (f) =>
              (widget.movie != null && f.movie?.id == widget.movie!.id) ||
              (widget.actor != null && f.actor?.id == widget.actor!.id),
        );
        await FavoriteService.instance.removeFromFavorites(favoriteToRemove.id);
      } else {
        // Add to favorites
        if (widget.movie != null) {
          await FavoriteService.instance.addMovieToFavorites(widget.movie!);
        } else if (widget.actor != null) {
          await FavoriteService.instance.addActorToFavorites(widget.actor!);
        }
      }

      setState(() => _isFavorite = !_isFavorite);

      // Show feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite ? 'Đã thêm vào yêu thích' : 'Đã xóa khỏi yêu thích',
            ),
            backgroundColor: _isFavorite ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Có lỗi xảy ra, vui lòng thử lại'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleFavorite,
      borderRadius: BorderRadius.circular(widget.size),
      child: Container(
        padding: EdgeInsets.all(widget.size * 0.2),
        child:
            _isLoading
                ? SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.color ?? Colors.red,
                    ),
                  ),
                )
                : Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: widget.size,
                  color:
                      _isFavorite ? Colors.red : (widget.color ?? Colors.white),
                ),
      ),
    );
  }
}
