import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/custom_button.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.home),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: Text('Order Success', style: AppTextStyles.heading3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bag icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 60,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'Your order was\nsuccessfull !',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading2,
            ),

            const SizedBox(height: 12),

            Text(
              'You will get a response within\na few minutes.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 48),

            CustomButton(
              text: 'Track order',
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.trackOrder),
            ),
          ],
        ),
      ),
    );
  }
}
