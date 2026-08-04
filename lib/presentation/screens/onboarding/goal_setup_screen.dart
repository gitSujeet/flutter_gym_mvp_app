import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../providers/auth_provider.dart';

class GoalSetupScreen extends ConsumerStatefulWidget {
  const GoalSetupScreen({super.key});

  @override
  ConsumerState<GoalSetupScreen> createState() => _GoalSetupScreenState();
}

class _GoalSetupScreenState extends ConsumerState<GoalSetupScreen> {
  String? _selectedGoal;
  String? _selectedLevel;

  final List<_GoalOption> _goals = [
    _GoalOption(id: 'lose_weight', label: 'Lose Weight', icon: Icons.monitor_weight_outlined),
    _GoalOption(id: 'build_muscle', label: 'Build Muscle', icon: Icons.fitness_center),
    _GoalOption(id: 'endurance', label: 'Improve Endurance', icon: Icons.directions_run),
    _GoalOption(id: 'stay_healthy', label: 'Stay Healthy', icon: Icons.favorite_outline),
  ];

  final List<_GoalOption> _levels = [
    _GoalOption(id: 'beginner', label: 'Beginner', icon: Icons.star_border),
    _GoalOption(id: 'intermediate', label: 'Intermediate', icon: Icons.star_half),
    _GoalOption(id: 'advanced', label: 'Advanced', icon: Icons.star),
  ];

  void _continue() async {
    if (_selectedGoal == null || _selectedLevel == null) return;
    final prefs = await ref.read(prefsServiceProvider.future);
    await prefs.setOnboarded();
    if (mounted) context.go(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text("What's your goal?",
                  style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 8),
              Text("We'll personalize your plan.",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: _goals
                    .map((g) => _SelectableCard(
                          option: g,
                          isSelected: _selectedGoal == g.id,
                          onTap: () => setState(() => _selectedGoal = g.id),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 32),
              Text("Your fitness level?",
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              ...  _levels.map(
                (l) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SelectableListTile(
                    option: l,
                    isSelected: _selectedLevel == l.id,
                    onTap: () => setState(() => _selectedLevel = l.id),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: 'Continue',
                onPressed: _selectedGoal != null && _selectedLevel != null
                    ? _continue
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalOption {
  final String id;
  final String label;
  final IconData icon;
  const _GoalOption({required this.id, required this.label, required this.icon});
}

class _SelectableCard extends StatelessWidget {
  final _GoalOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(option.icon,
                size: 32,
                color: isSelected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(height: 8),
            Text(
              option.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectableListTile extends StatelessWidget {
  final _GoalOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableListTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(option.icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 12),
            Text(
              option.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
