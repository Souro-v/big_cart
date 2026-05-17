import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../widgets/app_image.dart';
import '../../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full screen background image
          AppImage(
            url: AppAssets.authWelcome,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // Bottom curved white card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome', style: AppTextStyles.heading1),
                  const SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textGrey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Google button
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppAssets.icGoogle, height: 24),
                        const SizedBox(width: 12),
                        Text('Continue with Google',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Create account
                  CustomButton(
                    text: 'Create an account',
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                  ),

                  const SizedBox(height: 16),

                  // Login
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.login),
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textGrey,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}