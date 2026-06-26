import 'package:fitness/models/step_log_model.dart';
import 'package:fitness/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class StepService {
  final FirestoreService _firestoreService;
  final String _userId;

  int _todaySteps = 0;

  StepService(this._firestoreService, this._userId);

  Future<void> updateStepsManually(int steps) async {
    try {
      _todaySteps = steps;

      await _firestoreService.updateTodayStepLog(_userId, _todaySteps);

      final prefs = await SharedPreferences.getInstance();

      final todayStr = DateTime.now().toIso8601String().split('T')[0];

      await prefs.setInt('todaySteps', steps);
      await prefs.setString('lastSavedDate', todayStr);

      print('✅ Steps updated: $steps');
    } catch (e) {
      print('❌ Error updating steps manually: $e');
    }
  }

  Future<int> getTodaysSteps() async {
    try {
      final List<StepLogModel> logs = await _firestoreService
          .getSteps(_userId)
          .first;

      if (logs.isEmpty) {
        return 0;
      }

      final now = DateTime.now();

      final todayStart = DateTime(now.year, now.month, now.day);

      final tomorrowStart = todayStart.add(const Duration(days: 1));

      StepLogModel? todayLog;

      try {
        todayLog = logs.firstWhere(
          (log) =>
              log.timestamp.isAfter(todayStart) &&
              log.timestamp.isBefore(tomorrowStart),
        );
      } catch (_) {
        todayLog = StepLogModel(
          id: const Uuid().v4(),
          userId: _userId,
          steps: 0,
          timestamp: DateTime.now(),
        );
      }

      return todayLog.steps;
    } catch (e) {
      print("❌ Error fetching today's steps: $e");
      return 0;
    }
  }

  Future<void> addSteps(int stepsToAdd) async {
    try {
      final currentSteps = await getTodaysSteps();

      final newSteps = currentSteps + stepsToAdd;

      await updateStepsManually(newSteps);
    } catch (e) {
      print("❌ Error adding steps: $e");
    }
  }

  Future<int> getStepGoal() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return prefs.getInt('stepGoal') ?? 10000;
    } catch (e) {
      print("❌ Error getting step goal: $e");
      return 10000;
    }
  }

  void dispose() {}
}
