import 'dart:convert';
import 'package:hive/hive.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Box get _workoutBox => Hive.box('workoutBox');
  Box get _dietBox => Hive.box('dietBox');
  Box get _weightBox => Hive.box('weightBox');
  Box get _settingsBox => Hive.box('settingsBox');

  // ─── Workout Methods ───

  Future<void> markWorkoutDayComplete(int day) async {
    final completed = getCompletedWorkoutDays();
    if (!completed.contains(day)) {
      completed.add(day);
      await _workoutBox.put('completedDays', jsonEncode(completed));
    }
    await _workoutBox.put(
        'completedDate_$day', DateTime.now().toIso8601String());
  }

  bool isWorkoutDayComplete(int day) {
    return getCompletedWorkoutDays().contains(day);
  }

  List<int> getCompletedWorkoutDays() {
    final data = _workoutBox.get('completedDays');
    if (data == null) return [];
    return List<int>.from(jsonDecode(data));
  }

  DateTime? getWorkoutCompletionDate(int day) {
    final dateStr = _workoutBox.get('completedDate_$day');
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  Future<void> saveExerciseDuration(
      int day, String exerciseName, int seconds) async {
    final durations = getExerciseDurations(day);
    durations[exerciseName] = seconds;
    await _workoutBox.put('durations_$day', jsonEncode(durations));
  }

  Map<String, int> getExerciseDurations(int day) {
    final data = _workoutBox.get('durations_$day');
    if (data == null) return {};
    return Map<String, int>.from(jsonDecode(data));
  }

  Future<void> clearExerciseDuration(int day, String exerciseName) async {
    final durations = getExerciseDurations(day);
    durations.remove(exerciseName);
    await _workoutBox.put('durations_$day', jsonEncode(durations));
  }

  int getWorkoutStreak() {
    final completed = getCompletedWorkoutDays()..sort();
    if (completed.isEmpty) return 0;
    int streak = 1;
    int maxStreak = 1;
    for (int i = 1; i < completed.length; i++) {
      if (completed[i] == completed[i - 1] + 1) {
        streak++;
        if (streak > maxStreak) maxStreak = streak;
      } else {
        streak = 1;
      }
    }
    return maxStreak;
  }

  // ─── Diet Methods ───

  Future<void> markDietDayComplete(int day, String dietType) async {
    final completed = getCompletedDietDays();
    if (!completed.contains(day)) {
      completed.add(day);
      await _dietBox.put('completedDays', jsonEncode(completed));
    }
    await _dietBox.put('dietType_$day', dietType);
    await _dietBox.put('completedDate_$day', DateTime.now().toIso8601String());
  }

  bool isDietDayComplete(int day) {
    return getCompletedDietDays().contains(day);
  }

  List<int> getCompletedDietDays() {
    final data = _dietBox.get('completedDays');
    if (data == null) return [];
    return List<int>.from(jsonDecode(data));
  }

  String? getDietType(int day) {
    return _dietBox.get('dietType_$day');
  }

  DateTime? getDietCompletionDate(int day) {
    final dateStr = _dietBox.get('completedDate_$day');
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  // ─── Weight Methods ───

  Future<void> addWeightEntry(DateTime date, double weight) async {
    final history = getWeightHistory();
    history.add({
      'date': date.toIso8601String(),
      'weight': weight,
    });
    await _weightBox.put('history', jsonEncode(history));
  }

  List<Map<String, dynamic>> getWeightHistory() {
    final data = _weightBox.get('history');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(
      (jsonDecode(data) as List).map((e) => Map<String, dynamic>.from(e)),
    );
  }

  Future<void> deleteWeightEntry(int index) async {
    final history = getWeightHistory();
    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      await _weightBox.put('history', jsonEncode(history));
    }
  }

  // ─── Profile Methods ───

  Future<void> saveUserProfile({
    double? height,
    double? weight,
    int? age,
    String? gender,
  }) async {
    final profile = getUserProfile();
    if (height != null) profile['height'] = height;
    if (weight != null) profile['weight'] = weight;
    if (age != null) profile['age'] = age;
    if (gender != null) profile['gender'] = gender;
    await _settingsBox.put('profile', jsonEncode(profile));
  }

  Map<String, dynamic> getUserProfile() {
    final data = _settingsBox.get('profile');
    if (data == null) return {};
    return Map<String, dynamic>.from(jsonDecode(data));
  }
}
