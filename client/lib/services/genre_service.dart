import 'package:firebase_database/firebase_database.dart';

class GenreService {
  final _db = FirebaseDatabase.instance.ref();

  Future<List<Map<String, dynamic>>> fetchGenres() async {
    final snapshot = await _db.child('genres').get();
    if (!snapshot.exists) return [];

    final data = snapshot.value;
    if (data is List) {
      return data.whereType<Map>().cast<Map<String, dynamic>>().toList();
    } else if (data is Map) {
      return data.values.whereType<Map>().cast<Map<String, dynamic>>().toList();
    }
    return [];
  }
}
