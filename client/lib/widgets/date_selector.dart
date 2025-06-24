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

  @override
  void initState() {
    super.initState();
    // Tạo danh sách 30 ngày từ hôm nay
    dates = List.generate(30, (index) {
      return DateTime.now().add(Duration(days: index));
    });
    _pageController = PageController(
      initialPage: widget.selectedIndex,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: PageView.builder(
        controller: _pageController,
        itemCount: dates.length,
        onPageChanged: (index) {
          widget.onTap(index, dates[index]);
        },
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = index == widget.selectedIndex;
          final isToday =
              DateTime.now().day == date.day &&
              DateTime.now().month == date.month &&
              DateTime.now().year == date.year;

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
                        : Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
                border:
                    isToday && !isSelected
                        ? Border.all(color: Colors.red, width: 1)
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
                              : Colors.grey[400],
                      fontSize: 14,
                      fontWeight:
                          isSelected || isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                  if (isToday)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
