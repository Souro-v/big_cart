import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const LoadingIndicator({super.key, this.color, this.size = 36});

  // Full screen loader
  static Widget fullScreen() => const Scaffold(
    body: Center(child: LoadingIndicator()),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size, height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation(color ?? AppColors.primary),
        ),
      ),
    );
  }
}
