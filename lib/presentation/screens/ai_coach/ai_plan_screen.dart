import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../providers/ai_provider.dart';

class AiPlanScreen extends ConsumerStatefulWidget {
  const AiPlanScreen({super.key});

  @override
  ConsumerState<AiPlanScreen> createState() => _AiPlanScreenState();
}

class _AiPlanScreenState extends ConsumerState<AiPlanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _goal = 'build_muscle';
  String _level = 'intermediate';
  int _days = 4;
  bool _generated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Plan Generator'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Workout Plan'),
            Tab(text: 'Meal Plan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _WorkoutPlanTab(
            goal: _goal,
            level: _level,
            days: _days,
            generated: _generated,
            onGoalChanged: (v) => setState(() => _goal = v),
            onLevelChanged: (v) => setState(() => _level = v),
            onDaysChanged: (v) => setState(() => _days = v),
            onGenerate: () => setState(() => _generated = true),
          ),
          _MealPlanTab(goal: _goal),
        ],
      ),
    );
  }
}

class _WorkoutPlanTab extends ConsumerWidget {
  final String goal;
  final String level;
  final int days;
  final bool generated;
  final ValueChanged<String> onGoalChanged;
  final ValueChanged<String> onLevelChanged;
  final ValueChanged<int> onDaysChanged;
  final VoidCallback onGenerate;

  const _WorkoutPlanTab({
    required this.goal,
    required this.level,
    required this.days,
    required this.generated,
    required this.onGoalChanged,
    required this.onLevelChanged,
    required this.onDaysChanged,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (generated) {
      final planAsync = ref.watch(aiWorkoutPlanProvider({
        'fitnessGoal': goal,
        'activityLevel': level,
        'daysPerWeek': days,
      }));

      return planAsync.when(
        loading: () => const LoadingIndicator(message: 'Generating your plan...'),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: AppColors.error)),
        ),
        data: (plan) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              plan,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.7,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customize Your Plan',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          _DropdownField(
            label: 'Fitness Goal',
            value: goal,
            items: const {
              'lose_weight': 'Lose Weight',
              'build_muscle': 'Build Muscle',
              'endurance': 'Improve Endurance',
              'stay_healthy': 'Stay Healthy',
            },
            onChanged: onGoalChanged,
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: 'Fitness Level',
            value: level,
            items: const {
              'beginner': 'Beginner',
              'intermediate': 'Intermediate',
              'advanced': 'Advanced',
            },
            onChanged: onLevelChanged,
          ),
          const SizedBox(height: 16),
          Text('Days Per Week', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [3, 4, 5, 6]
                .map((d) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => onDaysChanged(d),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: days == d
                                ? AppColors.primary
                                : AppColors.cardDark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '$d',
                              style: TextStyle(
                                color: days == d
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 32),
          CustomButton(
            label: 'Generate Workout Plan',
            onPressed: onGenerate,
            prefixIcon: Icons.auto_awesome,
          ),
        ],
      ),
    );
  }
}

class _MealPlanTab extends ConsumerStatefulWidget {
  final String goal;
  const _MealPlanTab({required this.goal});

  @override
  ConsumerState<_MealPlanTab> createState() => _MealPlanTabState();
}

class _MealPlanTabState extends ConsumerState<_MealPlanTab> {
  bool _generated = false;
  double _calories = 2000;

  @override
  Widget build(BuildContext context) {
    if (_generated) {
      final planAsync = ref.watch(aiMealPlanProvider({
        'targetCalories': _calories,
        'fitnessGoal': widget.goal,
      }));

      return planAsync.when(
        loading: () => const LoadingIndicator(message: 'Creating your meal plan...'),
        error: (e, _) =>
            Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.error))),
        data: (plan) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(16)),
            child: Text(plan,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    height: 1.7,
                    fontFamily: 'Poppins')),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calorie Target', style: Theme.of(context).textTheme.titleMedium),
          Text('${_calories.toInt()} kcal/day',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.primary,
                  )),
          Slider(
            value: _calories,
            min: 1200,
            max: 4000,
            divisions: 28,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => _calories = v),
          ),
          const SizedBox(height: 32),
          CustomButton(
            label: 'Generate Meal Plan',
            onPressed: () => setState(() => _generated = true),
            prefixIcon: Icons.restaurant_menu,
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final Map<String, String> items;
  final ValueChanged<String> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.cardDark,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontFamily: 'Poppins'),
              items: items.entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList(),
              onChanged: (v) => onChanged(v!),
            ),
          ),
        ),
      ],
    );
  }
}
