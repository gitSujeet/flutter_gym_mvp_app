import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(label: 'Calories', value: '1,840', unit: 'kcal', color: AppColors.warning),
          _Divider(),
          _StatItem(label: 'Protein', value: '142', unit: 'g', color: AppColors.accent),
          _Divider(),
          _StatItem(label: 'Water', value: '2.1', unit: 'L', color: AppColors.info),
          _Divider(),
          _StatItem(label: 'Steps', value: '6,240', unit: '', color: AppColors.success),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
        if (unit.isNotEmpty)
          Text(unit,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 10, fontFamily: 'Poppins')),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontFamily: 'Poppins')),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: AppColors.textMuted.withOpacity(0.3));
  }
}
