import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle heading1 = TextStyle(
    fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textDark,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textDark,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textGrey,
  );
  static const TextStyle buttonText = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white,
  );
  static const TextStyle label = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textGrey,
  );
}
