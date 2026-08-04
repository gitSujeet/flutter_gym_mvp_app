import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../providers/nutrition_provider.dart';

class MealLogScreen extends ConsumerStatefulWidget {
  const MealLogScreen({super.key});

  @override
  ConsumerState<MealLogScreen> createState() => _MealLogScreenState();
}

class _MealLogScreenState extends ConsumerState<MealLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  String _mealType = 'breakfast';

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _logMeal() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(nutritionNotifierProvider.notifier).logMeal(
      name: _nameController.text.trim(),
      mealType: _mealType,
      calories: double.parse(_caloriesController.text),
      proteinG: double.parse(_proteinController.text),
      carbsG: double.parse(_carbsController.text),
      fatG: double.parse(_fatController.text),
    );
    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_nameController.text} logged successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Meal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal type selector
              Text('Meal Type', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: ['breakfast', 'lunch', 'dinner', 'snack']
                    .map((type) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _mealType = type),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: _mealType == type
                                    ? AppColors.primary
                                    : AppColors.cardDark,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                type[0].toUpperCase() + type.substring(1),
                                style: TextStyle(
                                  color: _mealType == type
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: _mealType == type
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _nameController,
                label: 'Food Name',
                hint: 'e.g. Grilled Chicken Breast',
                validator: (v) => Validators.required(v, fieldName: 'Food name'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _caloriesController,
                label: 'Calories (kcal)',
                hint: '0',
                keyboardType: TextInputType.number,
                validator: Validators.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _proteinController,
                      label: 'Protein (g)',
                      hint: '0',
                      keyboardType: TextInputType.number,
                      validator: Validators.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _carbsController,
                      label: 'Carbs (g)',
                      hint: '0',
                      keyboardType: TextInputType.number,
                      validator: Validators.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _fatController,
                      label: 'Fat (g)',
                      hint: '0',
                      keyboardType: TextInputType.number,
                      validator: Validators.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: 'Log Meal',
                onPressed: _logMeal,
                prefixIcon: Icons.add_circle_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
