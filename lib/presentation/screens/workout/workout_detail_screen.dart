import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final String workoutId;

  const WorkoutDetailScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: const Center(
                  child: Icon(Icons.fitness_center, size: 80, color: Colors.white54),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upper Body Strength',
                      style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _InfoChip(icon: Icons.timer_outlined, label: '45 min'),
                      const SizedBox(width: 8),
                      _InfoChip(icon: Icons.list_alt, label: '6 exercises'),
                      const SizedBox(width: 8),
                      _InfoChip(
                          icon: Icons.bar_chart,
                          label: 'Intermediate',
                          color: AppColors.warning),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Exercises', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  ...List.generate(
                    6,
                    (i) => _ExerciseRow(index: i + 1),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    label: 'Start Workout',
                    onPressed: () =>
                        context.push('/workouts/$workoutId/active'),
                    prefixIcon: Icons.play_arrow_rounded,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.color = AppColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 12, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  final int index;
  const _ExerciseRow({required this.index});

  static const _names = [
    'Bench Press', 'Pull-ups', 'Overhead Press',
    'Dumbbell Rows', 'Tricep Dips', 'Bicep Curls',
  ];

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
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_names[index - 1],
                    style: Theme.of(context).textTheme.titleMedium),
                const Text('3 sets × 12 reps',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontFamily: 'Poppins')),
              ],
            ),
          ),
          const Text('60s rest',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}
