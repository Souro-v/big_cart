import 'package:flutter/material.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';

enum NavTab { home, wishlist, cart, profile }

class BottomNavBar extends StatelessWidget {
  final NavTab currentTab;

  const BottomNavBar({super.key, required this.currentTab});

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
          _NavItem(
            icon: AppAssets.icHome,
            isActive: currentTab == NavTab.home,
            onTap: () {
              if (currentTab != NavTab.home) {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              }
            },
          ),
          _NavItem(
            icon: AppAssets.icwish,
            isActive: currentTab == NavTab.wishlist,
            onTap: () {
              if (currentTab != NavTab.wishlist) {
                Navigator.pushNamed(context, AppRoutes.favorites);
              }
            },
          ),
          _NavItem(
            icon: AppAssets.icOrder,
            isActive: currentTab == NavTab.cart,
            onTap: () {
              if (currentTab != NavTab.cart) {
                Navigator.pushNamed(context, AppRoutes.cart);
              }
            },
          ),
          _NavItem(
            icon: AppAssets.icUser,
            isActive: currentTab == NavTab.profile,
            onTap: () {
              if (currentTab != NavTab.profile) {
                Navigator.pushReplacementNamed(context, AppRoutes.profile);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            height: 24,
            color: isActive ? AppColors.primary : AppColors.textLight,
          ),
          if (isActive) ...[
            const SizedBox(height: 4),
            Container(
              width: 6, height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}