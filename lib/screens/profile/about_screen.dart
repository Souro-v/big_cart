import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_assets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: Text('About App', style: AppTextStyles.heading3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Logo
            Image.asset(AppAssets.logo, height: 80),
            const SizedBox(height: 16),

            Text(
              'BIG CART',
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.primary,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 4),
            Text('Version 1.0.0', style: AppTextStyles.bodySmall),

            const SizedBox(height: 32),

            // Info cards
            _InfoCard(
              icon: Icons.info_outline,
              title: 'About',
              content:
                  'Big Cart is a modern grocery delivery app that brings fresh products to your doorstep. We offer a wide range of fruits, vegetables, beverages, and household items at the best prices.',
            ),

            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.developer_mode_outlined,
              title: 'Developer',
              content: 'Developed with ❤️ using Flutter & Firebase.',
            ),

            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              content:
                  'We respect your privacy. Your personal data is encrypted and never shared with third parties.',
            ),

            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              content:
                  'By using Big Cart, you agree to our terms of service. All purchases are subject to availability.',
            ),

            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.support_agent_outlined,
              title: 'Support',
              content:
                  'Having issues? Contact us at support@bigcart.com\nWe\'re available 24/7 to help you.',
            ),

            const SizedBox(height: 24),

            // Social links
            Text('Follow Us', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialButton(
                  icon: Icons.facebook,
                  color: const Color(0xFF1877F2),
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                _SocialButton(
                  icon: Icons.camera_alt_outlined,
                  color: const Color(0xFFE4405F),
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                _SocialButton(
                  icon: Icons.telegram,
                  color: const Color(0xFF0088CC),
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 32),

            Text(
              '© 2026 Big Cart. All rights reserved.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textGrey,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: AppTextStyles.bodySmall.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
