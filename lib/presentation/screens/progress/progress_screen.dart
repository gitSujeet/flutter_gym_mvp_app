import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String _selectedRange = '1M';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Progress')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats row
            Row(
              children: [
                _StatCard(
                    label: 'Workouts', value: '24', icon: Icons.fitness_center),
                const SizedBox(width: 12),
                _StatCard(
                    label: 'This Week', value: '3', icon: Icons.calendar_today),
                const SizedBox(width: 12),
                _StatCard(
                    label: 'Streak', value: '7d', icon: Icons.local_fire_department),
              ],
            ),
            const SizedBox(height: 24),
            // Weight chart
            Text('Body Weight', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            // Time range selector
            Row(
              children: ['1W', '1M', '3M', '6M', '1Y'].map((r) {
                final isSelected = r == _selectedRange;
                return GestureDetector(
                  onTap: () => setState(() => _selectedRange = r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.cardDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(r,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        )),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            _WeightChart(),
            const SizedBox(height: 24),
            Text('Recent Workouts',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ..._recentWorkouts.map((w) => _WorkoutLogTile(workout: w)),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
    );
  }

  final List<Map<String, String>> _recentWorkouts = [
    {'title': 'Upper Body Strength', 'date': 'Today', 'duration': '47 min'},
    {'title': 'Full Body HIIT', 'date': 'Yesterday', 'duration': '31 min'},
    {'title': 'Morning Cardio', 'date': 'Jul 2', 'duration': '25 min'},
    {'title': 'Lower Body Focus', 'date': 'Jun 30', 'duration': '52 min'},
  ];
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins')),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}

class _WeightChart extends StatelessWidget {
  final List<FlSpot> _spots = const [
    FlSpot(0, 82.5),
    FlSpot(1, 81.9),
    FlSpot(2, 81.5),
    FlSpot(3, 80.8),
    FlSpot(4, 80.2),
    FlSpot(5, 79.9),
    FlSpot(6, 79.3),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.textMuted.withOpacity(0.1),
              strokeWidth: 1,
            ),
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, _) => Text(
                  '${value.toInt()}kg',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const days = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7'];
                  final i = value.toInt();
                  if (i < 0 || i >= days.length) return const SizedBox();
                  return Text(days[i],
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 10));
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _spots,
              isCurved: true,
              gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent]),
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.primary,
                  strokeColor: AppColors.backgroundDark,
                  strokeWidth: 2,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    AppColors.primary.withOpacity(0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutLogTile extends StatelessWidget {
  final Map<String, String> workout;
  const _WorkoutLogTile({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_circle, color: AppColors.success, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(workout['title']!,
                    style: Theme.of(context).textTheme.titleMedium),
                Text(workout['date']!,
                    style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontFamily: 'Poppins')),
              ],
            ),
          ),
          Text(workout['duration']!,
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}
