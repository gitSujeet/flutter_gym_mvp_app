import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _workoutReminders = true;
  bool _mealReminders = false;
  String _units = 'metric';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: 'Notifications'),
            _SwitchTile(
              label: 'Push Notifications',
              value: _notificationsEnabled,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
            ),
            _SwitchTile(
              label: 'Workout Reminders',
              subtitle: 'Daily at 7:00 AM',
              value: _workoutReminders,
              onChanged: (v) => setState(() => _workoutReminders = v),
            ),
            _SwitchTile(
              label: 'Meal Reminders',
              subtitle: 'Breakfast, Lunch, Dinner',
              value: _mealReminders,
              onChanged: (v) => setState(() => _mealReminders = v),
            ),
            const SizedBox(height: 20),
            _SectionHeader(title: 'Units'),
            Row(
              children: ['metric', 'imperial'].map((unit) {
                final isSelected = unit == _units;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _units = unit),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                          right: unit == 'metric' ? 8 : 0),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.15)
                            : AppColors.cardDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent),
                      ),
                      child: Column(
                        children: [
                          Text(
                            unit == 'metric' ? 'Metric' : 'Imperial',
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            unit == 'metric' ? 'kg, cm, km' : 'lbs, ft, mi',
                            style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _SectionHeader(title: 'About'),
            _InfoTile(label: 'Version', value: '1.0.0'),
            _InfoTile(label: 'Build', value: '100'),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title,
          style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              fontFamily: 'Poppins')),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontFamily: 'Poppins')),
                if (subtitle != null)
                  Text(subtitle!,
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          fontFamily: 'Poppins')),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontFamily: 'Poppins')),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}
