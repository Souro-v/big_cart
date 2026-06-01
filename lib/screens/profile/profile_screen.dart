import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/error_snackbar.dart';

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
            Text('Select Photo', style: AppTextStyles.heading3),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pop(context, ImageSource.camera),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.camera_alt,
                              color: AppColors.primary, size: 32),
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
                    onTap: () =>
                        Navigator.pop(context, ImageSource.gallery),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.photo_library,
                              color: AppColors.primary, size: 32),
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

    if (mounted) {
      final auth = context.read<AuthProvider>();
      await auth.updateUser(
        auth.user!.copyWith(imageUrl: base64Image),
      );
      ErrorSnackbar.showSuccess(context, 'Profile photo updated!');
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    final List<Map<String, dynamic>> items = [
      {'icon': Icons.person_outline,        'title': 'About me',      'route': AppRoutes.editProfile},
      {'icon': Icons.shopping_bag_outlined,  'title': 'My Orders',    'route': AppRoutes.myOrders},
      {'icon': Icons.favorite_border,        'title': 'My Favorites', 'route': AppRoutes.favorites},
      {'icon': Icons.location_on_outlined,   'title': 'My Address',   'route': AppRoutes.myAddress},
      {'icon': Icons.credit_card_outlined,   'title': 'Credit Cards', 'route': AppRoutes.myCards},
      {'icon': Icons.receipt_long_outlined,  'title': 'Transactions', 'route': AppRoutes.transactions},
      {'icon': Icons.notifications_outlined, 'title': 'Notifications','route': AppRoutes.notification},
      {'icon': Icons.info_outline,           'title': 'About App',    'route': AppRoutes.about},
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
                    backgroundImage: user?.imageUrl.isNotEmpty == true
                        ? (user!.imageUrl.startsWith('data:image')
                        ? MemoryImage(base64Decode(
                        user.imageUrl.split(',')[1]))
                        : NetworkImage(user.imageUrl)
                    as ImageProvider)
                        : null,
                    child: user?.imageUrl.isEmpty != false
                        ? const Icon(Icons.person,
                        size: 50, color: AppColors.textLight)
                        : null,
                  ),
                  GestureDetector(
                    onTap: () => _pickImage(context),
                    child: Container(
                      width: 28, height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          color: AppColors.white, size: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(user?.name ?? 'User',
                  style: AppTextStyles.heading3),
              const SizedBox(height: 4),
              Text(user?.email ?? '',
                  style: AppTextStyles.bodySmall),

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
                    ...items.map((item) => _MenuItem(
                      icon: item['icon'],
                      title: item['title'],
                      onTap: () => Navigator.pushNamed(
                          context, item['route']),
                    )),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.logout,
                      title: 'Sign out',
                      showArrow: false,
                      onTap: () async {
                        await context.read<AuthProvider>().logout();
                        if (context.mounted) {
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
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.login);
                          }
                        }
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
            Expanded(
              child: Text(title, style: AppTextStyles.bodyMedium),
            ),
            if (showArrow)
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}