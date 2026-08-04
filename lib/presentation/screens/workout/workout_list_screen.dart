import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../providers/workout_provider.dart';

class WorkoutListScreen extends ConsumerStatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  ConsumerState<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends ConsumerState<WorkoutListScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Strength', 'HIIT', 'Cardio', 'Yoga'];

  @override
  Widget build(BuildContext context) {
    final workoutsAsync = ref.watch(workoutsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      body: Column(
        children: [
          // Category filter
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.cardDark,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontFamily: 'Poppins',
                            fontSize: 13,
                          )),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: workoutsAsync.when(
              loading: () => const LoadingIndicator(message: 'Loading workouts...'),
              error: (e, _) => Center(
                child: Text('Error: $e',
                    style: const TextStyle(color: AppColors.error)),
              ),
              data: (workouts) {
                final filtered = _selectedCategory == 'All'
                    ? workouts
                    : workouts
                        .where((w) => w.category == _selectedCategory)
                        .toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('No workouts found',
                        style: TextStyle(color: AppColors.textMuted)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final workout = filtered[index];
                    return _WorkoutCard(
                      workout: {
                        'id': workout.id,
                        'title': workout.title,
                        'category': workout.category,
                        'duration': workout.estimatedMinutes,
                        'difficulty': workout.difficulty,
                        'exercises': workout.exercises.length,
                        'isCompleted': workout.isCompleted,
                      },
                      onTap: () => context.push('/workouts/${workout.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final Map<String, dynamic> workout;
  final VoidCallback onTap;

  const _WorkoutCard({required this.workout, required this.onTap});

  Color _difficultyColor(String diff) {
    switch (diff) {
      case 'Beginner': return AppColors.success;
      case 'Intermediate': return AppColors.warning;
      case 'Advanced': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = workout['isCompleted'] == true;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: isCompleted
              ? Border.all(color: AppColors.success.withOpacity(0.4))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success.withOpacity(0.15)
                    : AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.fitness_center,
                color: isCompleted ? AppColors.success : AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(workout['title'],
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text('${workout['duration']} min',
                          style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                              fontFamily: 'Poppins')),
                      const SizedBox(width: 12),
                      const Icon(Icons.list_alt,
                          size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text('${workout['exercises']} exercises',
                          style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                              fontFamily: 'Poppins')),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _difficultyColor(workout['difficulty']).withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                workout['difficulty'],
                style: TextStyle(
                  color: _difficultyColor(workout['difficulty']),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
