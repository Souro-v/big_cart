import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
      height: 22, width: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation(AppColors.white),
      ),
    )
        : Text(text, style: AppTextStyles.buttonText.copyWith(
      color: isOutlined ? AppColors.primary : AppColors.white,
    ));

    final btn = isOutlined
        ? OutlinedButton(onPressed: onPressed, child: child)
        : ElevatedButton(onPressed: onPressed, child: child);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: btn,
    );
  }
}
