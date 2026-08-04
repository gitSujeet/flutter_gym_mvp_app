import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../shared/widgets/custom_button.dart';
import 'widgets/macro_chart.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calorie summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text('Calories Today',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'Poppins')),
                  const SizedBox(height: 4),
                  const Text('1,840 / 2,200',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins')),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.84,
                      backgroundColor: Colors.white24,
                      color: Colors.white,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('360 kcal remaining',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'Poppins')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Macro chart
            Text('Macros', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const MacroChart(),
            const SizedBox(height: 24),
            // Meals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's Meals",
                    style: Theme.of(context).textTheme.titleLarge),
                TextButton(
                  onPressed: () => context.push(AppRoutes.mealLog),
                  child: const Text('+ Log Meal',
                      style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...[
              {'name': 'Breakfast', 'cal': '480', 'items': 'Oats, Banana, Eggs'},
              {'name': 'Lunch', 'cal': '620', 'items': 'Chicken Rice Bowl'},
              {'name': 'Snack', 'cal': '180', 'items': 'Greek Yogurt, Almonds'},
              {'name': 'Dinner', 'cal': '560', 'items': 'Salmon, Sweet Potato'},
            ].map((meal) => _MealTile(meal: meal)),
            const SizedBox(height: 24),
            CustomButton(
              label: 'Get AI Meal Plan',
              onPressed: () => context.push(AppRoutes.aiPlan),
              prefixIcon: Icons.auto_awesome,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}

class _MealTile extends StatelessWidget {
  final Map<String, String> meal;
  const _MealTile({required this.meal});

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
          const Icon(Icons.restaurant_menu,
              color: AppColors.success, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal['name']!,
                    style: Theme.of(context).textTheme.titleMedium),
                Text(meal['items']!,
                    style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontFamily: 'Poppins')),
              ],
            ),
          ),
          Text('${meal['cal']} kcal',
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}
