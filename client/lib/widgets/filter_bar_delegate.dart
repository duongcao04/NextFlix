import 'package:flutter/material.dart';

class FilterBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildChip('Đề xuất', selected: true),
            const SizedBox(width: 6),
            _buildChip('Phim bộ'),
            const SizedBox(width: 6),
            _buildChip('Phim lẻ'),
            const SizedBox(width: 6),
            _buildChip('Thể loại ⌄'),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool selected = false}) {
    return FilterChip(
      selected: selected,
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      onSelected: (_) {},
      selectedColor: Colors.white,
      backgroundColor: Colors.transparent,
      side: const BorderSide(color: Colors.white, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      showCheckmark: false,
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
