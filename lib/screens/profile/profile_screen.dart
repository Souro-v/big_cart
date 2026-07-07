import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/error_snackbar.dart';
import '../../widgets/shimmer_loading.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUploading = false;

  Future<void> _pickImage(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Photo', style: AppTextStyles.heading3),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: AppColors.primary,
                            size: 32,
                          ),
                          SizedBox(height: 8),
                          Text('Camera'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.photo_library,
                            color: AppColors.primary,
                            size: 32,
                          ),
                          SizedBox(height: 8),
                          Text('Gallery'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (source == null) return;

    if (!mounted) return;
    setState(() => _isUploading = true);

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 50,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (picked == null) {
      if (mounted) setState(() => _isUploading = false);
      return;
    }

    final bytes = await picked.readAsBytes();
    final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

    if (!mounted) return;
    final auth = context.read<AuthProvider>();

    if (auth.user != null) {
      await auth.updateUser(auth.user!.copyWith(imageUrl: base64Image));
      if (!mounted) return;
      ErrorSnackbar.showSuccess(context, 'Profile photo updated!');
    }

    if (mounted) {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.person_outline,
        'title': 'About me',
        'route': AppRoutes.editProfile,
      },
      {
        'icon': Icons.shopping_bag_outlined,
        'title': 'My Orders',
        'route': AppRoutes.myOrders,
      },
      {
        'icon': Icons.favorite_border,
        'title': 'My Favorites',
        'route': AppRoutes.favorites,
      },
      {
        'icon': Icons.location_on_outlined,
        'title': 'My Address',
        'route': AppRoutes.myAddress,
      },
      {
        'icon': Icons.credit_card_outlined,
        'title': 'Credit Cards',
        'route': AppRoutes.myCards,
      },
      {
        'icon': Icons.receipt_long_outlined,
        'title': 'Transactions',
        'route': AppRoutes.transactions,
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'Notifications',
        'route': AppRoutes.notification,
      },
      {
        'icon': Icons.privacy_tip_outlined,
        'title': 'Privacy Settings',
        'route': AppRoutes.privacy,
      },
      {
        'icon': Icons.info_outline,
        'title': 'About App',
        'route': AppRoutes.about,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNavBar(currentTab: NavTab.profile),
      body: SafeArea(
        child: _isUploading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text('Uploading photo...'),
                  ],
                ),
              )
            : user == null
                ? _ProfileShimmer()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 32),

                        // Profile image
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.surface,
                              backgroundImage: user.imageUrl.isNotEmpty == true
                                  ? (user.imageUrl.startsWith('data:image')
                                      ? MemoryImage(
                                          base64Decode(
                                            user.imageUrl.split(',')[1],
                                          ),
                                        )
                                      : NetworkImage(user.imageUrl)
                                          as ImageProvider)
                                  : null,
                              child: user.imageUrl.isEmpty != false
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: AppColors.textLight,
                                    )
                                  : null,
                            ),
                            GestureDetector(
                              onTap: () => _pickImage(context),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: AppColors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _ProfileCompletion(user: user),
                        const SizedBox(height: 12),
                        //refer code
                        Text(user.name, style: AppTextStyles.heading3),
                        if (user.referralCode.isNotEmpty == true) ...[
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Share.share(
                                'Join Big Cart with my referral code: ${user.referralCode}\nGet 10% off your first order!',
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Code: ${user.referralCode}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.share,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        // loyalty points
                        if (user.points > 0) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.warning),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.stars,
                                  size: 16,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${user.points} Points',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 4),
                        Text(user.email, style: AppTextStyles.bodySmall),

                        const SizedBox(height: 24),

                        // Menu items
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
                              ...items.map(
                                (item) => _MenuItem(
                                  icon: item['icon'],
                                  title: item['title'],
                                  onTap: () => Navigator.pushNamed(
                                      context, item['route']),
                                ),
                              ),
                              const Divider(height: 1),
                              _MenuItem(
                                icon: Icons.logout,
                                title: 'Sign out',
                                showArrow: false,
                                onTap: () async {
                                  final authProvider =
                                      context.read<AuthProvider>();
                                  final wishlistProvider =
                                      context.read<WishlistProvider>();

                                  await authProvider.logout();
                                  wishlistProvider.clearLocal();

                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Logged out!'),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: AppColors.primary,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );

                                  await Future.delayed(
                                      const Duration(seconds: 2));

                                  if (!context.mounted) return;
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.login,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class _ProfileShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Avatar shimmer
          const Center(
            child: ShimmerLoading(width: 100, height: 100, borderRadius: 50),
          ),
          const SizedBox(height: 12),

          // Name shimmer
          const Center(child: ShimmerLoading(width: 120, height: 16)),
          const SizedBox(height: 8),
          const Center(child: ShimmerLoading(width: 180, height: 12)),

          const SizedBox(height: 24),

          // Menu items shimmer
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(
                6,
                (_) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: ShimmerLoading(width: double.infinity, height: 56),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showArrow;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),
            if (showArrow)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textGrey,
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCompletion extends StatelessWidget {
  final UserModel? user;

  const _ProfileCompletion({this.user});

  int get _completionPercent {
    int score = 0;
    if (user?.name.isNotEmpty == true) score += 25;
    if (user?.email.isNotEmpty == true) score += 25;
    if (user?.phone.isNotEmpty == true) score += 25;
    if (user?.imageUrl.isNotEmpty == true) score += 25;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    if (_completionPercent == 100) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Completion',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$_completionPercent%',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _completionPercent / 100,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 6,
            ),
          ),
          if (_completionPercent < 100) ...[
            const SizedBox(height: 4),
            Text(
              'Complete your profile for better experience',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
