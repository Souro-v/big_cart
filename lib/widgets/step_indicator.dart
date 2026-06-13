import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  const StepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Step(
          number: 1,
          label: 'DELIVERY',
          done: currentStep > 1,
          isActive: currentStep == 1,
        ),
        _StepLine(active: currentStep > 1),
        _Step(
          number: 2,
          label: 'ADDRESS',
          done: currentStep > 2,
          isActive: currentStep == 2,
        ),
        _StepLine(active: currentStep > 2),
        _Step(
          number: 3,
          label: 'PAYMENT',
          done: currentStep > 3,
          isActive: currentStep == 3,
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final int number;
  final String label;
  final bool done;
  final bool isActive;

  const _Step({
    required this.number,
    required this.label,
    this.done = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: done || isActive
                ? AppColors.primary
                : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: done || isActive
                  ? AppColors.primary
                  : AppColors.border,
            ),
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check,
                color: Colors.white, size: 16)
                : Text(
              '$number',
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : AppColors.textGrey,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: done || isActive
                ? AppColors.primary
                : AppColors.textGrey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool active;
  const _StepLine({this.active = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: active ? AppColors.primary : AppColors.border,
      ),
    );
  }
}