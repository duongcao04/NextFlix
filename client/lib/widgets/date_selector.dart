import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  final int selectedIndex;
  final Function(int, DateTime) onTap;

  const DateSelector({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late PageController _pageController;
  late List<DateTime> dates;
  late int todayIndex;

  @override
  void initState() {
    super.initState();

    // Tạo danh sách ngày: 7 ngày trước + hôm nay + 30 ngày sau
    final today = DateTime.now();
    dates = [];

    // Thêm 7 ngày trước
    for (int i = 7; i >= 1; i--) {
      dates.add(today.subtract(Duration(days: i)));
    }

    // Thêm hôm nay
    todayIndex = dates.length; // Index của hôm nay
    dates.add(today);

    // Thêm 30 ngày sau
    for (int i = 1; i <= 30; i++) {
      dates.add(today.add(Duration(days: i)));
    }

    // Nếu không có selectedIndex được truyền vào, mặc định là hôm nay
    final initialPage =
        widget.selectedIndex == 0 ? todayIndex : widget.selectedIndex;

    _pageController = PageController(
      initialPage: initialPage,
      viewportFraction: 0.25, // Hiển thị 4 ngày cùng lúc
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Thứ 2',
      'Thứ 3',
      'Thứ 4',
      'Thứ 5',
      'Thứ 6',
      'Thứ 7',
      'Chủ nhật',
    ];
    return weekdays[weekday - 1];
  }

  String _getDateString(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;
  }

  bool _isPastDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);
    return compareDate.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 8),

      child: Column(
        children: [
          // Indicator để hiển thị có thể vuốt
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Vuốt để xem thêm ngày',
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: dates.length,
              onPageChanged: (index) {
                widget.onTap(index, dates[index]);
              },
              itemBuilder: (context, index) {
                final date = dates[index];
                final isSelected = index == widget.selectedIndex;
                final isToday = _isToday(date);
                final isPast = _isPastDate(date);

                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    widget.onTap(index, date);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.red
                              : isToday
                              ? Colors.red.withOpacity(0.3)
                              : isPast
                              ? Colors.grey[850]
                              : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                      border:
                          isToday && !isSelected
                              ? Border.all(color: Colors.red, width: 1)
                              : isPast && !isSelected
                              ? Border.all(color: Colors.grey[700]!, width: 1)
                              : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getWeekdayName(date.weekday),
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : isToday
                                    ? Colors.red
                                    : isPast
                                    ? Colors.grey[500]
                                    : Colors.grey[400],
                            fontSize: 12,
                            fontWeight:
                                isSelected || isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),

                        const SizedBox(height: 4),
                        Text(
                          _getDateString(date),
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : isToday
                                    ? Colors.red
                                    : isPast
                                    ? Colors.grey[500]
                                    : Colors.grey[400],
                            fontSize: 14,
                            fontWeight:
                                isSelected || isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isToday)
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            if (isPast && !isToday)
                              Icon(
                                Icons.history,
                                size: 8,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.grey[500],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
