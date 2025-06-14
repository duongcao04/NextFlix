import 'package:flutter/material.dart';
import 'package:nextflix/models/topic_model.dart';
import 'package:nextflix/services/topic_service.dart';

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Các chủ đề'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Topic>>(
        future: TopicService().fetchTopics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Không có chủ đề nào',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final topics = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.8,
              children: topics.map((topic) => _buildTopicCard(topic)).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopicCard(Topic topic) {
    final color = _hexToColor(topic.color);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.85), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          topic.name,
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

  Color _hexToColor(String hex) {
    hex = hex.replaceAll(' ', '').replaceFirst('#', '');
    return Color(int.parse('0xff$hex'));
  }
}
