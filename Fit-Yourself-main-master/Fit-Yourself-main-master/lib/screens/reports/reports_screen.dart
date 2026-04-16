import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../data/storage_service.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/bmi_gauge.dart';
import '../../widgets/weight_chart.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  final _storage = StorageService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Your Progress',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.analytics, color: AppColors.accent),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Calendar'),
            Tab(text: 'Weight'),
            Tab(text: 'BMI'),
            Tab(text: 'BMR'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CalendarTab(storage: _storage),
          _WeightTab(storage: _storage),
          const _BMITab(),
          const _BMRTab(),
        ],
      ),
    );
  }
}

// ─── CALENDAR TAB ───

class _CalendarTab extends StatelessWidget {
  final StorageService storage;

  const _CalendarTab({required this.storage});

  @override
  Widget build(BuildContext context) {
    final workoutDays = storage.getCompletedWorkoutDays();
    final dietDays = storage.getCompletedDietDays();
    final streak = storage.getWorkoutStreak();
    final totalCompletion =
        ((workoutDays.length + dietDays.length) / (AppConstants.totalDays * 2) * 100)
            .toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '30-Day Overview',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _legendDot(AppColors.primary, 'Workout'),
              const SizedBox(width: 16),
              _legendDot(AppColors.success, 'Diet'),
              const SizedBox(width: 16),
              _legendDot(Colors.amber, 'Both'),
            ],
          ),
          const SizedBox(height: 12),

          // 5x6 Grid of days
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: AppConstants.totalDays,
            itemBuilder: (context, index) {
              final day = index + 1;
              final hasWorkout = workoutDays.contains(day);
              final hasDiet = dietDays.contains(day);
              final hasBoth = hasWorkout && hasDiet;

              Color bgColor;
              Color textColor = Colors.white;
              if (hasBoth) {
                bgColor = Colors.amber;
                textColor = Colors.black;
              } else if (hasWorkout) {
                bgColor = AppColors.primary;
              } else if (hasDiet) {
                bgColor = AppColors.success;
              } else {
                bgColor = AppColors.card;
                textColor = AppColors.textSecondary;
              }

              return Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      if (hasBoth)
                        const Icon(Icons.star, size: 12, color: Colors.black54),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _summaryRow('Total Workout Days',
                    '${workoutDays.length}/${AppConstants.totalDays}'),
                const SizedBox(height: 8),
                _summaryRow('Total Diet Days',
                    '${dietDays.length}/${AppConstants.totalDays}'),
                const SizedBox(height: 8),
                _summaryRow('Overall Completion', '$totalCompletion%'),
                const SizedBox(height: 8),
                _summaryRow('Best Streak', '$streak days'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Share Progress
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                final weightHistory = storage.getWeightHistory();
                double? startWeight;
                double? currentWeight;
                if (weightHistory.isNotEmpty) {
                  startWeight =
                      (weightHistory.first['weight'] as num).toDouble();
                  currentWeight =
                      (weightHistory.last['weight'] as num).toDouble();
                }
                final text = Helpers.generateProgressText(
                  workoutDays: workoutDays.length,
                  dietDays: dietDays.length,
                  startWeight: startWeight,
                  currentWeight: currentWeight,
                  streak: streak,
                );
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Progress copied to clipboard!')),
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('Share Progress'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 14, color: AppColors.textSecondary)),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
      ],
    );
  }
}

// ─── WEIGHT TAB ───

class _WeightTab extends StatefulWidget {
  final StorageService storage;

  const _WeightTab({required this.storage});

  @override
  State<_WeightTab> createState() => _WeightTabState();
}

class _WeightTabState extends State<_WeightTab> {
  final _weightController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final history = widget.storage.getWeightHistory();
    double? change;
    if (history.length >= 2) {
      final first = (history.first['weight'] as num).toDouble();
      final last = (history.last['weight'] as num).toDouble();
      change = last - first;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input Row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: AppColors.primary,
                                    surface: AppColors.card,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.card),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('MMM d, y').format(_selectedDate),
                                style: GoogleFonts.poppins(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _weightController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          hintText: 'kg',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        final weight = double.tryParse(_weightController.text);
                        if (weight != null && weight > 0 && weight < 500) {
                          widget.storage
                              .addWeightEntry(_selectedDate, weight);
                          _weightController.clear();
                          setState(() {});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Enter a valid weight')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(50, 46),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (change != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: change <= 0
                    ? AppColors.success.withValues(alpha: 0.15)
                    : AppColors.error.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Change: ${change >= 0 ? "+" : ""}${change.toStringAsFixed(1)} kg since start',
                  style: GoogleFonts.poppins(
                    color: change <= 0 ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Chart
          WeightChart(entries: history),

          const SizedBox(height: 16),

          // History List
          Text(
            'History',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          if (history.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No weight entries yet',
                  style: GoogleFonts.poppins(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ...history.reversed.toList().asMap().entries.map((entry) {
              final actualIndex = history.length - 1 - entry.key;
              final item = entry.value;
              final date = DateTime.parse(item['date']);
              final weight = (item['weight'] as num).toDouble();
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${DateFormat('MMM d, y').format(date)} — ${weight.toStringAsFixed(1)} kg',
                        style: GoogleFonts.poppins(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.error, size: 20),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: AppColors.card,
                            title: Text('Delete Entry?',
                                style: GoogleFonts.poppins(
                                    color: AppColors.textPrimary)),
                            content: Text('Remove this weight entry?',
                                style: GoogleFonts.poppins(
                                    color: AppColors.textSecondary)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel',
                                    style: GoogleFonts.poppins(
                                        color: AppColors.textSecondary)),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.storage.deleteWeightEntry(actualIndex);
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Text('Delete',
                                    style: GoogleFonts.poppins(
                                        color: AppColors.error)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

// ─── BMI TAB ───

class _BMITab extends StatefulWidget {
  const _BMITab();

  @override
  State<_BMITab> createState() => _BMITabState();
}

class _BMITabState extends State<_BMITab> {
  double _height = 170;
  double _weight = 70;
  double? _bmi;
  final _heightController = TextEditingController(text: '170');
  final _weightController = TextEditingController(text: '70');

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculate() {
    setState(() {
      _bmi = Helpers.calculateBMI(_weight, _height);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Height
          Text('Height (cm)',
              style: GoogleFonts.poppins(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final val = double.tryParse(v);
                    if (val != null && val >= 100 && val <= 250) {
                      setState(() => _height = val);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Slider(
                  value: _height.clamp(100, 250),
                  min: 100,
                  max: 250,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.surface,
                  onChanged: (v) {
                    setState(() {
                      _height = v;
                      _heightController.text = v.toInt().toString();
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Weight
          Text('Weight (kg)',
              style: GoogleFonts.poppins(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _weightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final val = double.tryParse(v);
                    if (val != null && val >= 30 && val <= 200) {
                      setState(() => _weight = val);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Slider(
                  value: _weight.clamp(30, 200),
                  min: 30,
                  max: 200,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.surface,
                  onChanged: (v) {
                    setState(() {
                      _weight = v;
                      _weightController.text = v.toStringAsFixed(1);
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _calculate,
            child: const Text('Calculate BMI'),
          ),

          if (_bmi != null) ...[
            const SizedBox(height: 24),
            Center(
              child: Text(
                _bmi!.toStringAsFixed(1),
                style: GoogleFonts.poppins(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: _bmiColor(_bmi!),
                ),
              ),
            ),
            Center(
              child: Text(
                Helpers.getBMICategory(_bmi!),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _bmiColor(_bmi!),
                ),
              ),
            ),

            const SizedBox(height: 20),

            BMIGauge(bmi: _bmi!),

            const SizedBox(height: 20),

            // Reference Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BMI Categories',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      )),
                  const SizedBox(height: 10),
                  _bmiRow('Underweight', '< 18.5', Colors.blue.shade400),
                  _bmiRow('Normal Weight', '18.5 - 24.9', AppColors.success),
                  _bmiRow('Overweight', '25 - 29.9', Colors.orange),
                  _bmiRow('Obese', '>= 30', AppColors.error),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _bmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blue.shade400;
    if (bmi < 25) return AppColors.success;
    if (bmi < 30) return Colors.orange;
    return AppColors.error;
  }

  Widget _bmiRow(String category, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(category,
                style: GoogleFonts.poppins(
                    color: AppColors.textSecondary, fontSize: 13)),
          ),
          Text(range,
              style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ─── BMR TAB ───

class _BMRTab extends StatefulWidget {
  const _BMRTab();

  @override
  State<_BMRTab> createState() => _BMRTabState();
}

class _BMRTabState extends State<_BMRTab> {
  int _age = 25;
  bool _isMale = true;
  double _height = 170;
  double _weight = 70;
  double? _bmr;
  int _activityIndex = 2;

  final _ageController = TextEditingController(text: '25');
  final _heightController = TextEditingController(text: '170');
  final _weightController = TextEditingController(text: '70');

  static const _activityLevels = [
    {'label': 'Sedentary', 'multiplier': 1.2, 'desc': 'Little or no exercise'},
    {
      'label': 'Light',
      'multiplier': 1.375,
      'desc': 'Exercise 1-3 days/week'
    },
    {
      'label': 'Moderate',
      'multiplier': 1.55,
      'desc': 'Exercise 3-5 days/week'
    },
    {
      'label': 'Active',
      'multiplier': 1.725,
      'desc': 'Exercise 6-7 days/week'
    },
    {
      'label': 'Very Active',
      'multiplier': 1.9,
      'desc': 'Hard exercise daily'
    },
  ];

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculate() {
    setState(() {
      _bmr = Helpers.calculateBMR(
        weightKg: _weight,
        heightCm: _height,
        age: _age,
        isMale: _isMale,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tdee = _bmr != null
        ? Helpers.calculateTDEE(
            _bmr!, _activityLevels[_activityIndex]['multiplier'] as double)
        : null;
    final macros = tdee != null ? Helpers.calculateMacros(tdee) : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Age
          Text('Age',
              style: GoogleFonts.poppins(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_age > 10) {
                    setState(() {
                      _age--;
                      _ageController.text = '$_age';
                    });
                  }
                },
                icon: const Icon(Icons.remove_circle_outline,
                    color: AppColors.primary),
              ),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  ),
                  onChanged: (v) {
                    final val = int.tryParse(v);
                    if (val != null && val >= 10 && val <= 100) {
                      setState(() => _age = val);
                    }
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_age < 100) {
                    setState(() {
                      _age++;
                      _ageController.text = '$_age';
                    });
                  }
                },
                icon:
                    const Icon(Icons.add_circle_outline, color: AppColors.primary),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Gender
          Text('Gender',
              style: GoogleFonts.poppins(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isMale = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _isMale
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _isMale ? AppColors.primary : AppColors.surface,
                      ),
                    ),
                    child: Center(
                      child: Text('Male',
                          style: GoogleFonts.poppins(
                            color: _isMale
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isMale = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !_isMale
                          ? AppColors.accent.withValues(alpha: 0.2)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: !_isMale ? AppColors.accent : AppColors.surface,
                      ),
                    ),
                    child: Center(
                      child: Text('Female',
                          style: GoogleFonts.poppins(
                            color: !_isMale
                                ? AppColors.accent
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Height
          Text('Height (cm)',
              style: GoogleFonts.poppins(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            onChanged: (v) {
              final val = double.tryParse(v);
              if (val != null) setState(() => _height = val);
            },
          ),

          const SizedBox(height: 16),

          // Weight
          Text('Weight (kg)',
              style: GoogleFonts.poppins(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextField(
            controller: _weightController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            onChanged: (v) {
              final val = double.tryParse(v);
              if (val != null) setState(() => _weight = val);
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _calculate,
            child: const Text('Calculate BMR'),
          ),

          if (_bmr != null && tdee != null && macros != null) ...[
            const SizedBox(height: 24),

            Center(
              child: Text(
                'Your BMR: ${_bmr!.toInt()} cal/day',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            Center(
              child: Text(
                'You burn approximately ${_bmr!.toInt()} calories per day at rest',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text('Activity Level',
                style: GoogleFonts.poppins(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _activityLevels.asMap().entries.map((entry) {
                final isSelected = _activityIndex == entry.key;
                return ChoiceChip(
                  label: Text(entry.value['label'] as String),
                  selected: isSelected,
                  onSelected: (_) =>
                      setState(() => _activityIndex = entry.key),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: GoogleFonts.poppins(
                    color:
                        isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 6),
            Text(
              _activityLevels[_activityIndex]['desc'] as String,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Text(
                  'Daily Calorie Need: ${tdee.toInt()} calories',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Macro Split
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Macro Split',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      )),
                  const SizedBox(height: 12),
                  _macroRow('Protein (30%)',
                      '${macros['protein']!.toInt()}g', AppColors.primary),
                  const SizedBox(height: 8),
                  _macroRow('Carbs (45%)', '${macros['carbs']!.toInt()}g',
                      AppColors.accent),
                  const SizedBox(height: 8),
                  _macroRow('Fat (25%)', '${macros['fat']!.toInt()}g',
                      Colors.amber),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _macroRow(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label,
              style: GoogleFonts.poppins(
                  color: AppColors.textSecondary, fontSize: 14)),
        ),
        Text(value,
            style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
