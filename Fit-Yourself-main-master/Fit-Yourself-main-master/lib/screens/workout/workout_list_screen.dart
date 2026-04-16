import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../data/exercise_data.dart';
import '../../data/storage_service.dart';
import '../../utils/constants.dart';
import '../../widgets/day_card.dart';
import 'day_exercises_screen.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  final _storage = StorageService();
  late final _allDays = ExerciseData.getAllDays();

  @override
  Widget build(BuildContext context) {
    final completedDays = _storage.getCompletedWorkoutDays();
    final completedCount = completedDays.length;
    final streak = _storage.getWorkoutStreak();
    final percent = completedCount / AppConstants.totalDays;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Fit Yourself',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.fitness_center, color: AppColors.primary),
            onPressed: () {
              final quote = AppConstants.motivationalQuotes[
                  DateTime.now().millisecond %
                      AppConstants.motivationalQuotes.length];
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(quote,
                      style: GoogleFonts.poppins(fontStyle: FontStyle.italic)),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 40,
                    lineWidth: 6,
                    percent: percent.clamp(0.0, 1.0),
                    center: Text(
                      '${(percent * 100).toInt()}%',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    progressColor: Colors.white,
                    backgroundColor: Colors.white24,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Day $completedCount / ${AppConstants.totalDays}',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$completedCount Workouts Completed',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                        if (streak >= 3)
                          Text(
                            'Current Streak: $streak days',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),

            const SizedBox(height: 24),

            Text(
              '30-Day Full Body Workout',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Complete 7 exercises each day to transform your body',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 16),

            // Day List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _allDays.length,
              itemBuilder: (context, index) {
                final day = _allDays[index];
                final isCompleted = _storage.isWorkoutDayComplete(day.dayNumber);
                return DayCard(
                  dayNumber: day.dayNumber,
                  title: day.title,
                  subtitle:
                      '${day.exercises.length} Exercises - ~${day.estimatedMinutes} min',
                  isCompleted: isCompleted,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DayExercisesScreen(dayNumber: day.dayNumber),
                      ),
                    );
                    setState(() {});
                  },
                )
                    .animate()
                    .fadeIn(delay: (50 * index).ms, duration: 300.ms)
                    .slideX(begin: 0.2, end: 0);
              },
            ),
          ],
        ),
      ),
    );
  }
}
