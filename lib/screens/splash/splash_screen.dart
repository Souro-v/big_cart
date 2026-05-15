import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/app_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_SlideData> _slides = [
    _SlideData(
      imageUrl: AppAssets.splash1,
      title: 'Welcome to',
      isFirst: true,
      subtitle:
          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
    ),
    _SlideData(
      imageUrl: AppAssets.splash2,
      title: 'Buy Quality\nDairy Products',
      subtitle:
          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
    ),
    _SlideData(
      imageUrl: AppAssets.splash3,
      title: 'Buy Premium\nQuality Fruits',
      subtitle:
          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
    ),
    _SlideData(
      imageUrl: AppAssets.splash4,
      title: 'Get Discounts\nOn All Products',
      subtitle:
          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
    ),
  ];

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Pages
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) => _SlidePage(data: _slides[i]),
            ),
          ),

          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == i ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == i
                      ? AppColors.primary
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CustomButton(text: 'Get Started', onPressed: _next),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SlidePage extends StatelessWidget {
  final _SlideData data;

  const _SlidePage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 60),

        // Title
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading2,
        ),

        // First slide এ logo দেখাবে
        if (data.isFirst) ...[
          const SizedBox(height: 8),
          Image.asset(AppAssets.logo, height: 40),
        ],

        const SizedBox(height: 12),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textGrey,
              height: 1.6,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Image
        Expanded(
          child: AppImage(
            url: data.imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class _SlideData {
  final String imageUrl;
  final String title;
  final String subtitle;
  final bool isFirst;

  _SlideData({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.isFirst = false,
  });
}
