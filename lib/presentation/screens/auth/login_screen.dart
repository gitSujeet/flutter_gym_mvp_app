import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(authNotifierProvider.notifier);
    final success = await notifier.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (success && mounted) context.go(AppRoutes.home);
  }

  Future<void> _signInWithGoogle() async {
    final notifier = ref.read(authNotifierProvider.notifier);
    final success = await notifier.signInWithGoogle();
    if (success && mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final error = authState.hasError ? authState.error.toString() : null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Welcome Back 👋',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue your fitness journey',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 40),
                if (error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Text(error,
                        style: const TextStyle(color: AppColors.error)),
                  ),
                  const SizedBox(height: 16),
                ],
                CustomTextField(
                  controller: _emailController,
                  label: AppStrings.email,
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  label: AppStrings.password,
                  hint: '••••••••',
                  obscureText: true,
                  validator: Validators.password,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(AppStrings.forgotPassword,
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  label: AppStrings.signIn,
                  onPressed: isLoading ? null : _signIn,
                  isLoading: isLoading,
                ),
                const SizedBox(height: 16),
                Row(children: [
                  const Expanded(child: Divider(color: AppColors.textMuted)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or', style: TextStyle(color: AppColors.textMuted)),
                  ),
                  const Expanded(child: Divider(color: AppColors.textMuted)),
                ]),
                const SizedBox(height: 16),
                CustomButton(
                  label: AppStrings.continueWithGoogle,
                  onPressed: isLoading ? null : _signInWithGoogle,
                  isOutlined: true,
                  prefixIcon: Icons.g_mobiledata,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(AppStrings.dontHaveAccount,
                        style: TextStyle(color: AppColors.textSecondary)),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.register),
                      child: const Text(AppStrings.signUp,
                          style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
