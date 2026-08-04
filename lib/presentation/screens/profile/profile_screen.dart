import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('${AppRoutes.profile}/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary,
              backgroundImage: user?.photoUrl != null
                  ? NetworkImage(user!.photoUrl!)
                  : null,
              child: user?.photoUrl == null
                  ? Text(
                      (user?.name ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(user?.name ?? 'Athlete',
                style: Theme.of(context).textTheme.headlineMedium),
            Text(user?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            // Stats
            Row(
              children: [
                _ProfileStat(label: 'Workouts', value: '24'),
                _ProfileStat(label: 'Streak', value: '7d'),
                _ProfileStat(label: 'kg Lost', value: '3.2'),
              ],
            ),
            const SizedBox(height: 24),
            // Body stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Body Stats',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _BodyStatTile(
                          label: 'Weight',
                          value: user?.weightKg != null
                              ? '${user!.weightKg}kg'
                              : '--'),
                      _BodyStatTile(
                          label: 'Height',
                          value: user?.heightCm != null
                              ? '${user!.heightCm}cm'
                              : '--'),
                      _BodyStatTile(
                          label: 'Age',
                          value: user?.age != null ? '${user!.age}' : '--'),
                      _BodyStatTile(
                          label: 'Goal',
                          value: user?.fitnessGoal?.replaceAll('_', ' ') ?? '--'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Menu items
            ...[
              _MenuItem(
                  icon: Icons.edit_outlined,
                  label: 'Edit Profile',
                  onTap: () {}),
              _MenuItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onTap: () {}),
              _MenuItem(
                  icon: Icons.help_outline,
                  label: 'Help & Support',
                  onTap: () {}),
              _MenuItem(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy Policy',
                  onTap: () {}),
              _MenuItem(
                icon: Icons.logout,
                label: 'Sign Out',
                onTap: () async {
                  await ref.read(authNotifierProvider.notifier).signOut();
                  if (context.mounted) context.go(AppRoutes.login);
                },
                isDestructive: true,
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: AppColors.primary,
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

class _BodyStatTile extends StatelessWidget {
  final String label;
  final String value;

  const _BodyStatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins')),
        Text(label,
            style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontFamily: 'Poppins')),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: color, fontSize: 15, fontFamily: 'Poppins')),
            const Spacer(),
            if (!isDestructive)
              const Icon(Icons.arrow_forward_ios,
                  color: AppColors.textMuted, size: 14),
          ],
        ),
      ),
    );
  }
}
