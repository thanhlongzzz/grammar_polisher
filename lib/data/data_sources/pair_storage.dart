import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract interface class PairStorage {
  Future<void> saveMarkedLesson(Map<int, bool> markedLessons);

  Map<int, bool> getMarkedLesson();
}

class SharedPreferencesStorage implements PairStorage {
  static const String _markedLessonsKey = 'marked_lessons';
  final SharedPreferences _sharedPreferences;

  const SharedPreferencesStorage({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Map<int, bool> getMarkedLesson() {
    final markedLessonJson = _sharedPreferences.getString(_markedLessonsKey);
    if (markedLessonJson == null) {
      return {};
    }
    final markedLessonMap = jsonDecode(markedLessonJson) as Map<String, dynamic>;
    return markedLessonMap.map((key, value) => MapEntry(int.parse(key), value as bool));
  }

  @override
  Future<void> saveMarkedLesson(Map<int, bool> markedLessons) async {
    var markedLessonJson = jsonEncode(markedLessons.map((key, value) => MapEntry(key.toString(), value)));
    await _sharedPreferences.setString(_markedLessonsKey, markedLessonJson);
  }
}
