import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _logoController;
  late AnimationController _pageController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _pageOpacity;

  // Onboarding
  final PageController _onboardingController = PageController();
  int _currentPage = 0;
  bool _showOnboarding = false;

  final List<_SlideData> _slides = [
    _SlideData(
      imageUrl: AppAssets.splash1,
      isFirst: true,
      title: 'Welcome to',
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

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSplash();
  }

  void _setupAnimations() {
    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Page transition animation
    _pageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _pageOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pageController, curve: Curves.easeOut));
  }

  Future<void> _startSplash() async {
    // Logo animate in
    await _logoController.forward();

    // Wait
    await Future.delayed(const Duration(milliseconds: 800));

    // Check auth + onboarding
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_seen') ?? false;
    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (user != null) {
      // Already logged in
      await _fadeOut();
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (seen) {
      // Seen onboarding
      await _fadeOut();
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    } else {
      // Show onboarding
      await _fadeOut();
      if (mounted) setState(() => _showOnboarding = true);
    }
  }

  Future<void> _fadeOut() async {
    await _pageController.forward();
  }

  Future<void> _next() async {
    if (_currentPage < _slides.length - 1) {
      _onboardingController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_seen', true);
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pageController.dispose();
    _onboardingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return _buildOnboarding();
    }
    return _buildSplash();
  }

  Widget _buildSplash() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _pageOpacity,
        child: Center(
          child: AnimatedBuilder(
            animation: _logoController,
            builder: (_, __) => Opacity(
              opacity: _logoOpacity.value,
              child: Transform.scale(
                scale: _logoScale.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppAssets.logo, height: 80),
                    const SizedBox(height: 16),
                    Text(
                      'BIG CART',
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.primary,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fresh Groceries Delivered Fast',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnboarding() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _onboardingController,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) => _SlidePage(data: _slides[i]),
          ),

          // Bottom overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
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

                  CustomButton(text: 'Get Started', onPressed: _next),
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
        AppImage(
          url: data.imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),

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

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
