import 'package:flutter/material.dart';

class BottomAppBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomAppBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: const BoxDecoration(
        color: Color(0xff0f1016), // Màu nền đen
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_filled, 'Trang chủ'),
          _buildNavItem(1, Icons.search, 'Tìm kiếm'),
          _buildNavItem(2, Icons.calendar_month, 'Lịch chiếu'),
          _buildNavItem(3, Icons.person, 'Tài khoản'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.amber : Colors.white, size: 24),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.amber : Colors.white,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
