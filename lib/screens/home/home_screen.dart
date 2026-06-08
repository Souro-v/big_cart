import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../services/flash_sale_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/recently_viewed_provider.dart';
import '../../widgets/app_image.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/product_card.dart';
import '../../widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBanner = 0;
  final PageController _bannerController = PageController();

  final List<String> _banners = [AppAssets.banner1];

  final List<Map<String, String>> _categories = [
    {'name': 'Vegetables', 'image': AppAssets.catVegetables},
    {'name': 'Fruits', 'image': AppAssets.catFruits},
    {'name': 'Beverages', 'image': AppAssets.catBeverages},
    {'name': 'Grocery', 'image': AppAssets.catGrocery},
    {'name': 'Edible oil', 'image': AppAssets.catEdibleOil},
    {'name': 'Household', 'image': AppAssets.catHousehold},
  ];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ProductProvider>().loadProducts();
        // Orders load
        final uid = context.read<AuthProvider>().user?.uid ?? '';
        if (uid.isNotEmpty) {
          context.read<OrderProvider>().listenToOrders(uid);
        }
      }
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductProvider>().loadMore();
    }
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().products;
    final isLoading = context.watch<ProductProvider>().isLoading;
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: const BottomNavBar(currentTab: NavTab.home),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await context.read<ProductProvider>().loadProducts();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.search),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.textGrey),
                          const SizedBox(width: 10),
                          Text(
                            'Search keywords..',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, AppRoutes.filter),
                            child: const Icon(
                              Icons.tune,
                              color: AppColors.textGrey,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Banner
                isLoading
                    ? const BannerShimmer()
                    : SizedBox(
                        height: 180,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _bannerController,
                              itemCount: _banners.length,
                              onPageChanged: (i) =>
                                  setState(() => _currentBanner = i),
                              itemBuilder: (_, i) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    children: [
                                      AppImage(
                                        url: _banners[i],
                                        width: double.infinity,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        left: 16,
                                        bottom: 32,
                                        child: Text(
                                          '20% off on your\nfirst purchase',
                                          style: AppTextStyles.heading3
                                              .copyWith(color: AppColors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _banners.length,
                                  (i) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    width: _currentBanner == i ? 16 : 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: _currentBanner == i
                                          ? AppColors.white
                                          : AppColors.white.withValues(
                                              alpha: 0.5,
                                            ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                const SizedBox(height: 20),
                // Flash Sale Timer widget
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: FlashSaleService().getActiveFlashSales(),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox();
                    }
                    return _FlashSaleSection(sales: snapshot.data!);
                  },
                ),

                // Categories
                if (isLoading) ...[
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 6,
                      itemBuilder: (_, __) => const CategoryShimmer(),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Categories', style: AppTextStyles.heading3),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.category),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      itemBuilder: (_, i) => _CategoryItem(
                        name: _categories[i]['name']!,
                        imageUrl: _categories[i]['image']!,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.products,
                          arguments: _categories[i]['name'],
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Featured products
                if (isLoading) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Featured products',
                          style: AppTextStyles.heading3,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.textGrey,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: 6,
                      itemBuilder: (_, __) => const ProductCardShimmer(),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Featured products',
                          style: AppTextStyles.heading3,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.textGrey,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        final p = products[i];
                        final qty = cart.isInCart(p.id)
                            ? cart.items
                                  .firstWhere((item) => item.product.id == p.id)
                                  .quantity
                            : 0;
                        return ProductCard(
                          product: p,
                          quantity: qty,
                          onAdd: () => cart.addToCart(p),
                          onIncrease: () => cart.increaseQty(p.id),
                          onDecrease: () => cart.decreaseQty(p.id),
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.productDetail,
                            arguments: p,
                          ),
                        );
                      },
                    ),
                  ),
                  if (context.watch<ProductProvider>().isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Recently Viewed
                  Consumer<RecentlyViewedProvider>(
                    builder: (_, recentlyViewed, __) {
                      if (recentlyViewed.isEmpty) return const SizedBox();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recently Viewed',
                                  style: AppTextStyles.heading3,
                                ),
                                GestureDetector(
                                  onTap: () => context
                                      .read<RecentlyViewedProvider>()
                                      .clear(),
                                  child: Text(
                                    'Clear',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: recentlyViewed.items.length,
                              itemBuilder: (_, i) {
                                final p = recentlyViewed.items[i];
                                final qty = cart.isInCart(p.id)
                                    ? cart.items
                                          .firstWhere(
                                            (item) => item.product.id == p.id,
                                          )
                                          .quantity
                                    : 0;
                                return SizedBox(
                                  width: 160,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: ProductCard(
                                      product: p,
                                      quantity: qty,
                                      onAdd: () => cart.addToCart(p),
                                      onIncrease: () => cart.increaseQty(p.id),
                                      onDecrease: () => cart.decreaseQty(p.id),
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        AppRoutes.productDetail,
                                        arguments: p,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                  //recent ordered
                  Consumer<OrderProvider>(
                    builder: (_, orderProvider, __) {
                      if (orderProvider.orders.isEmpty) return const SizedBox();
                      final lastOrder = orderProvider.orders.first;
                      if (lastOrder.items.isEmpty) return const SizedBox();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order Again',
                                  style: AppTextStyles.heading3,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.myOrders,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryLight,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.replay,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order #${lastOrder.id.substring(0, 5).toUpperCase()}',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          '${lastOrder.items.length} items • \$${lastOrder.totalAmount.toStringAsFixed(2)}',
                                          style: AppTextStyles.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final cartProvider = context
                                          .read<CartProvider>();
                                      cartProvider.clearCart();
                                      for (final item in lastOrder.items) {
                                        for (
                                          int i = 0;
                                          i < item.quantity;
                                          i++
                                        ) {
                                          cartProvider.addToCart(item.product);
                                        }
                                      }
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.cart,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(80, 36),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Reorder'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: ClipOval(
                child: AppImage(
                  url: imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlashSaleSection extends StatefulWidget {
  final List<Map<String, dynamic>> sales;

  const _FlashSaleSection({required this.sales});

  @override
  State<_FlashSaleSection> createState() => _FlashSaleSectionState();
}

class _FlashSaleSectionState extends State<_FlashSaleSection> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _calculateRemaining(),
    );
  }

  void _calculateRemaining() {
    if (widget.sales.isEmpty) return;
    final endTime = DateTime.parse(widget.sales.first['endTime'] as String);
    final now = DateTime.now();
    if (mounted) {
      setState(() => _remaining = endTime.difference(now));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text('Flash Sale', style: AppTextStyles.heading3),
                ],
              ),
              // Countdown timer
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_twoDigits(_remaining.inHours)}:${_twoDigits(_remaining.inMinutes.remainder(60))}:${_twoDigits(_remaining.inSeconds.remainder(60))}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
