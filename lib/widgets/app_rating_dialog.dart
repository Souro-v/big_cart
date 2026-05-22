import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class AppRatingDialog extends StatefulWidget {
  const AppRatingDialog({super.key});

  @override
  State<AppRatingDialog> createState() => _AppRatingDialogState();

  // Dialog  helper
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AppRatingDialog(),
    );
  }
}

class _AppRatingDialogState extends State<AppRatingDialog> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: AppColors.textGrey),
              ),
            ),

            // Icon
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 16),

            Text('Enjoying Big Cart?',
              style: AppTextStyles.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap a star to rate us on\nthe App Store',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 20),

            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFF3A93C),
                    size: 36,
                  ),
                ),
              )),
            ),

            const SizedBox(height: 24),

            // Rate button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _rating == 0
                    ? null
                    : () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Thanks for your rating! 🎉'),
                      backgroundColor: AppColors.primary,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.border,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Rate Now',
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Not now
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                'Not now',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}