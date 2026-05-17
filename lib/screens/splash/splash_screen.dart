import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../widgets/app_image.dart';
import '../../widgets/custom_button.dart';

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
      isFirst: true,
      title: 'Welcome to',
      subtitle: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
    ),
    _SlideData(
      imageUrl: AppAssets.splash2,
      title: 'Buy Quality\nDairy Products',
      subtitle: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
    ),
    _SlideData(
      imageUrl: AppAssets.splash3,
      title: 'Buy Premium\nQuality Fruits',
      subtitle: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
    ),
    _SlideData(
      imageUrl: AppAssets.splash4,
      title: 'Get Discounts\nOn All Products',
      subtitle: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
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
      body: Stack(
        children: [
          // Full screen PageView
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) => _SlidePage(data: _slides[i]),
          ),

          // Bottom overlay — dots + button
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
              child: Column(
                children: [
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
                              : AppColors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Button
                  CustomButton(
                    text: 'Get Started',
                    onPressed: _next,
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

class _SlidePage extends StatelessWidget {
  final _SlideData data;
  const _SlidePage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full screen background image
        AppImage(
          url: data.imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),

        // Dark overlay — image এর উপর হালকা dark
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.15),
                Colors.black.withValues(alpha: 0.5),
              ],
            ),
          ),
        ),

        // Top content — title + logo/subtitle
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First slide — "Welcome to" + logo
                if (data.isFirst) ...[
                  Text(
                    'Welcome to',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(AppAssets.logo, height: 40),
                ] else
                  Text(
                    data.title,
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.white,
                    ),
                  ),

                const SizedBox(height: 16),

                Text(
                  data.subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.85),
                    height: 1.6,
                  ),
                ),
              ],
            ),
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
    this.title = '',
    required this.subtitle,
    this.isFirst = false,
  });
}