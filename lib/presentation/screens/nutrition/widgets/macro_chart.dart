import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class MacroChart extends StatelessWidget {
  const MacroChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _MacroRow(
            label: 'Protein',
            current: 142,
            target: 180,
            color: AppColors.accent,
            unit: 'g',
          ),
          const SizedBox(height: 12),
          _MacroRow(
            label: 'Carbs',
            current: 195,
            target: 250,
            color: AppColors.warning,
            unit: 'g',
          ),
          const SizedBox(height: 12),
          _MacroRow(
            label: 'Fat',
            current: 58,
            target: 70,
            color: AppColors.error,
            unit: 'g',
          ),
        ],
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  final String label;
  final double current;
  final double target;
  final Color color;
  final String unit;

  const _MacroRow({
    required this.label,
    required this.current,
    required this.target,
    required this.color,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins')),
            Text(
              '${current.toInt()} / ${target.toInt()}$unit',
              style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontFamily: 'Poppins'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceDark,
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
