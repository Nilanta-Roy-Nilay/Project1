// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class WorkoutService extends ChangeNotifier {
  int _steps = 0;
  double _calories = 0;
  double _distance = 0;
  int _waterIntake = 0;
  int _heartRate = 72;
  int _sleep = 7;
  String? _selectedWorkout;
  int _currentDuration = 0;

  var workouts;

  int get steps => _steps;
  double get calories => _calories;
  double get distance => _distance;
  int get waterIntake => _waterIntake;
  int get heartRate => _heartRate;
  int get sleep => _sleep;
  String? get selectedWorkout => _selectedWorkout;

  void refreshData() {
    notifyListeners();
  }

  void selectWorkout(String workout) {
    _selectedWorkout = workout;
    notifyListeners();
  }

  void updateWorkoutDuration(int seconds) {
    _currentDuration = seconds;
    // Update calories based on workout type and duration
    if (_selectedWorkout == 'Running') {
      _calories = seconds * 0.1;
    } else if (_selectedWorkout == 'Cycling') {
      _calories = seconds * 0.08;
    } else if (_selectedWorkout == 'Yoga') {
      _calories = seconds * 0.05;
    }

    // Update steps (approximately)
    _steps = (seconds * 1.5).toInt();

    // Update distance
    _distance = seconds * 0.008;

    notifyListeners();
  }

  void endWorkout() {
    _selectedWorkout = null;
    _currentDuration = 0;
    notifyListeners();
  }

  void addWater() {
    _waterIntake += 250;
    notifyListeners();
  }

  void logSleep(int hours) {
    _sleep = hours;
    notifyListeners();
  }

  void updateHeartRate(int rate) {
    _heartRate = rate;
    notifyListeners();
  }
}
