import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to Profile Screen
              Navigator.pushNamed(context, '/profile');
            },
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today\'s Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),

              // Stats Grid - Row 1
              Row(
                children: [
                  _buildStatCard(
                    title: 'Steps',
                    value: '7,250',
                    icon: Icons.directions_walk,
                    color: Colors.blue,
                    onTap: () {
                      _showStatDetail(
                        context,
                        'Steps',
                        'You have taken 7,250 steps today. Keep moving!',
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    title: 'Calories',
                    value: '420',
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                    onTap: () {
                      _showStatDetail(
                        context,
                        'Calories',
                        'You have burned 420 calories today. Great job!',
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Stats Grid - Row 2
              Row(
                children: [
                  _buildStatCard(
                    title: 'Distance',
                    value: '5.2 km',
                    icon: Icons.map,
                    color: Colors.green,
                    onTap: () {
                      _showStatDetail(
                        context,
                        'Distance',
                        'You have covered 5.2 km today. Keep going!',
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    title: 'Active Min',
                    value: '45',
                    icon: Icons.timer,
                    color: Colors.purple,
                    onTap: () {
                      _showStatDetail(
                        context,
                        'Active Minutes',
                        'You have been active for 45 minutes today!',
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Recent Workouts Section
              const Text(
                'Recent Workouts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Workout List
              _buildWorkoutItem(
                title: 'Morning Run',
                duration: '30 min',
                calories: '300 kcal',
                icon: Icons.directions_run,
                color: Colors.blue,
                onTap: () {
                  _showWorkoutDetail(
                    context,
                    'Morning Run',
                    '30 min',
                    '300 kcal',
                  );
                },
              ),
              _buildWorkoutItem(
                title: 'Evening Yoga',
                duration: '45 min',
                calories: '200 kcal',
                icon: Icons.self_improvement,
                color: Colors.purple,
                onTap: () {
                  _showWorkoutDetail(
                    context,
                    'Evening Yoga',
                    '45 min',
                    '200 kcal',
                  );
                },
              ),
              _buildWorkoutItem(
                title: 'Strength Training',
                duration: '60 min',
                calories: '450 kcal',
                icon: Icons.fitness_center,
                color: Colors.orange,
                onTap: () {
                  _showWorkoutDetail(
                    context,
                    'Strength Training',
                    '60 min',
                    '450 kcal',
                  );
                },
              ),

              const SizedBox(height: 30),

              // Progress Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildProgressBar('Mon', 60)),
                        Expanded(child: _buildProgressBar('Tue', 75)),
                        Expanded(child: _buildProgressBar('Wed', 80)),
                        Expanded(child: _buildProgressBar('Thu', 55)),
                        Expanded(child: _buildProgressBar('Fri', 90)),
                        Expanded(child: _buildProgressBar('Sat', 70)),
                        Expanded(child: _buildProgressBar('Sun', 65)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80), // Extra space for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            // Already on Dashboard
          } else if (index == 1) {
            // Stats - Show coming soon
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Stats feature coming soon!')),
            );
          } else if (index == 2) {
            // Navigate to Profile
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutItem({
    required String title,
    required String duration,
    required String calories,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$duration • $calories',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.play_circle, color: Colors.green, size: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String day, double percentage) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 30,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: (percentage / 100) * 55,
                width: 25,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(day, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _showStatDetail(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showWorkoutDetail(
    BuildContext context,
    String title,
    String duration,
    String calories,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Duration: $duration'),
            const SizedBox(height: 8),
            Text('Calories: $calories'),
            const SizedBox(height: 8),
            const Text('Great workout! Keep it up! 💪'),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Starting $title...')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}
