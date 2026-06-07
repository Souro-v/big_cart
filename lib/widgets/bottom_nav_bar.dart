import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';

enum NavTab { home, wishlist, cart, profile }

class BottomNavBar extends StatelessWidget {
  final NavTab currentTab;

  const BottomNavBar({super.key, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;

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
          _NavItemWithBadge(
            icon: AppAssets.icOrder,
            isActive: currentTab == NavTab.cart,
            badgeCount: cartCount,
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
              width: 6,
              height: 6,
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

// _NavItemWithBadge AnimatedScale add
class _NavItemWithBadge extends StatefulWidget {
  final String icon;
  final bool isActive;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavItemWithBadge({
    required this.icon,
    required this.onTap,
    required this.badgeCount,
    this.isActive = false,
  });

  @override
  State<_NavItemWithBadge> createState() => _NavItemWithBadgeState();
}

class _NavItemWithBadgeState extends State<_NavItemWithBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _prevCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _prevCount = widget.badgeCount;
  }

  @override
  void didUpdateWidget(_NavItemWithBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.badgeCount > _prevCount) {
      _controller.forward().then((_) => _controller.reverse());
    }
    _prevCount = widget.badgeCount;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  widget.icon,
                  height: 24,
                  color: widget.isActive
                      ? AppColors.primary
                      : AppColors.textLight,
                ),
              ),
              if (widget.badgeCount > 0)
                Positioned(
                  top: -6,
                  right: -8,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          widget.badgeCount > 99
                              ? '99+'
                              : '${widget.badgeCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (widget.isActive) ...[
            const SizedBox(height: 4),
            Container(
              width: 6,
              height: 6,
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
