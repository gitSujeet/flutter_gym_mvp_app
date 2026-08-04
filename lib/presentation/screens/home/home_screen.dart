import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import 'widgets/daily_summary_card.dart';
import 'widgets/progress_ring.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning 🔥',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        user?.name ?? 'Athlete',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.profile),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary,
                      backgroundImage: user?.photoUrl != null
                          ? NetworkImage(user!.photoUrl!)
                          : null,
                      child: user?.photoUrl == null
                          ? Text(
                              (user?.name ?? 'U')[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Daily progress ring
              const ProgressRing(),
              const SizedBox(height: 24),

              // Daily summary cards
              const DailySummaryCard(),
              const SizedBox(height: 24),

              // Quick actions
              Text("Quick Actions",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _QuickActionCard(
                    icon: Icons.fitness_center,
                    label: 'Start Workout',
                    color: AppColors.primary,
                    onTap: () => context.push(AppRoutes.workouts),
                  ),
                  _QuickActionCard(
                    icon: Icons.smart_toy_outlined,
                    label: 'AI Coach',
                    color: AppColors.accent,
                    onTap: () => context.push(AppRoutes.aiChat),
                  ),
                  _QuickActionCard(
                    icon: Icons.restaurant_menu,
                    label: 'Log Meal',
                    color: AppColors.success,
                    onTap: () => context.push(AppRoutes.mealLog),
                  ),
                  _QuickActionCard(
                    icon: Icons.bar_chart,
                    label: 'Progress',
                    color: AppColors.warning,
                    onTap: () => context.push(AppRoutes.progress),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Today's workout preview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Today's Workout",
                      style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.workouts),
                    child: const Text('See All',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _TodayWorkoutCard(onTap: () => context.push(AppRoutes.workouts)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                )),
          ],
        ),
      ),
    );
  }
}

class _TodayWorkoutCard extends StatelessWidget {
  final VoidCallback onTap;
  const _TodayWorkoutCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.play_circle_filled, color: Colors.white, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upper Body Strength',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '6 exercises • 45 min',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
