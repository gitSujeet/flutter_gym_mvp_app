import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final String workoutId;

  const ActiveWorkoutScreen({super.key, required this.workoutId});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  int _currentExercise = 0;
  int _currentSet = 1;
  int _elapsedSeconds = 0;
  bool _isResting = false;
  int _restRemaining = 60;
  Timer? _timer;
  Timer? _restTimer;

  final List<String> _exercises = [
    'Bench Press', 'Pull-ups', 'Overhead Press',
    'Dumbbell Rows', 'Tricep Dips', 'Bicep Curls',
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });
  }

  void _completeSet() {
    if (_currentSet < 3) {
      setState(() {
        _currentSet++;
        _isResting = true;
        _restRemaining = 60;
      });
      _startRestTimer();
    } else if (_currentExercise < _exercises.length - 1) {
      setState(() {
        _currentExercise++;
        _currentSet = 1;
        _isResting = true;
        _restRemaining = 90;
      });
      _startRestTimer();
    } else {
      _finishWorkout();
    }
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _restRemaining--);
      if (_restRemaining <= 0) {
        t.cancel();
        setState(() => _isResting = false);
      }
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    setState(() => _isResting = false);
  }

  void _finishWorkout() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Workout Complete! 🎉',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'Great job! You completed all exercises in ${_formatTime(_elapsedSeconds)}.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context)
              ..pop()
              ..pop()
              ..pop(),
            child: const Text('Done', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_formatTime(_elapsedSeconds)),
        actions: [
          TextButton(
            onPressed: _finishWorkout,
            child: const Text('Finish',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentExercise * 3 + _currentSet - 1) / (_exercises.length * 3),
              backgroundColor: AppColors.surfaceDark,
              color: AppColors.primary,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${_currentExercise + 1} / ${_exercises.length} exercises',
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 12, fontFamily: 'Poppins'),
            ),
            const Spacer(),

            if (_isResting) ...[
              const Icon(Icons.timer, color: AppColors.accent, size: 60),
              const SizedBox(height: 16),
              Text(
                'Rest Time',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '$_restRemaining s',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: 'Skip Rest',
                onPressed: _skipRest,
                isOutlined: true,
              ),
            ] else ...[
              Text(
                _exercises[_currentExercise],
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final isCompleted = i < _currentSet - 1;
                  final isCurrent = i == _currentSet - 1;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.success
                          : isCurrent
                              ? AppColors.primary
                              : AppColors.cardDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'S${i + 1}',
                        style: TextStyle(
                          color: isCompleted || isCurrent
                              ? Colors.white
                              : AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              const Text(
                '12 reps',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              const Text('Body weight',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontFamily: 'Poppins')),
              const SizedBox(height: 40),
              CustomButton(
                label: 'Complete Set $_currentSet',
                onPressed: _completeSet,
                prefixIcon: Icons.check_rounded,
              ),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
