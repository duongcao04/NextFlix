import 'package:flutter/material.dart';

class TopicScreen extends StatelessWidget {
  final List<String> topics = [
    'Marvel', 'Keo Lỳ Slayyy', 'Sitcom', '4K',
    'Lồng Tiếng Cực Mạnh', 'Đỉnh Nóc', 'Xuyên Không', 'Cổ Trang',
    '9x', 'Tham Vọng', 'Chữa Lành', 'Phù Thủy',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Các chủ đề'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.8,
          children: topics.map((topic) => _buildTopicCard(topic)).toList(),
        ),
      ),
    );
  }

  Widget _buildTopicCard(String text) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFf857a6), Color(0xFFFF5858)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
