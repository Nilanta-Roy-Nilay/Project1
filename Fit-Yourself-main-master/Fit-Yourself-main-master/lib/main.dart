import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('workoutBox');
  await Hive.openBox('dietBox');
  await Hive.openBox('weightBox');
  await Hive.openBox('settingsBox');
  runApp(const FitYourselfApp());
}
