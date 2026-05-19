import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    final List<Map<String, dynamic>> _items = [
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
        'route': null,
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'Notifications',
        'route': null,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: _BottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
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
                        ? NetworkImage(user!.imageUrl)
                        : null,
                    child: user?.imageUrl.isEmpty != false
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.textLight,
                          )
                        : null,
                  ),
                  Container(
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
                ],
              ),

              const SizedBox(height: 12),

              Text(user?.name ?? 'User', style: AppTextStyles.heading3),
              const SizedBox(height: 4),
              Text(user?.email ?? '', style: AppTextStyles.bodySmall),

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
                    ..._items.map(
                      (item) => _MenuItem(
                        icon: item['icon'],
                        title: item['title'],
                        onTap: item['route'] != null
                            ? () => Navigator.pushNamed(context, item['route'])
                            : () {},
                      ),
                    ),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.logout,
                      title: 'Sign out',
                      showArrow: false,
                      onTap: () async {
                        await context.read<AuthProvider>().logout();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.welcome,
                          );
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

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: AppColors.textLight),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, AppRoutes.home),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.primary),
            onPressed: () {},
          ),
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.textLight),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.favorites),
          ),
        ],
      ),
    );
  }
}
