import 'package:firebase_database/firebase_database.dart';
import '../models/topic_model.dart';

class TopicService {
  final _db = FirebaseDatabase.instance.ref();

  Future<List<Topic>> fetchTopics() async {
    final snapshot = await _db.child('topics').once();
    final data = snapshot.snapshot.value;

    if (data == null || data is! List) return [];

    final topics = <Topic>[];
    for (final item in data) {
      if (item != null && item is Map) {
        topics.add(Topic.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return topics;
  }
}
