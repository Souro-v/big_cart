import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/app_image.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBanner = 0;
  final PageController _bannerController = PageController();

  final List<String> _banners = [
    AppAssets.banner1,
  ];

  final List<Map<String, String>> _categories = [
    {'name': 'Vegetables', 'image': AppAssets.catVegetables},
    {'name': 'Fruits',     'image': AppAssets.catFruits},
    {'name': 'Beverages',  'image': AppAssets.catBeverages},
    {'name': 'Grocery',    'image': AppAssets.catGrocery},
    {'name': 'Edible oil', 'image': AppAssets.catEdibleOil},
    {'name': 'Household',  'image': AppAssets.catHousehold},
  ];

  final Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ProductProvider>().loadProducts()
    );
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products  = context.watch<ProductProvider>().products;
    final isLoading = context.watch<ProductProvider>().isLoading;
    final cart      = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: _BottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.search),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.textGrey),
                        const SizedBox(width: 10),
                        Text('Search keywords..',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.tune, color: AppColors.textGrey, size: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // Banner
              SizedBox(
                height: 180,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _bannerController,
                      itemCount: _banners.length,
                      onPageChanged: (i) => setState(() => _currentBanner = i),
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              // Overlay text
                              Positioned(
                                left: 16, bottom: 32,
                                child: Text(
                                  '20% off on your\nfirst purchase',
                                  style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Dots
                    Positioned(
                      bottom: 10, left: 0, right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _banners.length,
                              (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentBanner == i ? 16 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentBanner == i
                                  ? AppColors.white
                                  : AppColors.white.withValues(alpha: 0.5),
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

              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Categories', style: AppTextStyles.heading3),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.category),
                      child: const Icon(Icons.arrow_forward_ios,
                          size: 16, color: AppColors.textGrey),
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
                      context, AppRoutes.category,
                      arguments: _categories[i]['name'],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Featured products
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Featured products', style: AppTextStyles.heading3),
                    const Icon(Icons.arrow_forward_ios,
                        size: 16, color: AppColors.textGrey),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              if (isLoading)
                const Center(child: CircularProgressIndicator(color: AppColors.primary))
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        isFavorite: _favorites.contains(p.id),
                        quantity: qty,
                        onFavorite: () => setState(() {
                          _favorites.contains(p.id)
                              ? _favorites.remove(p.id)
                              : _favorites.add(p.id);
                        }),
                        onAdd: () => cart.addToCart(p),
                        onIncrease: () => cart.increaseQty(p.id),
                        onDecrease: () => cart.decreaseQty(p.id),
                        onTap: () => Navigator.pushNamed(
                          context, AppRoutes.productDetail,
                          arguments: p,
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),
            ],
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
  const _CategoryItem({required this.name, required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: ClipOval(
                child: AppImage(
                  url: imageUrl,
                  width: 56, height: 56,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(name,
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
            icon: const Icon(Icons.home_outlined, color: AppColors.primary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.textLight),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
          // Cart FAB
          Consumer<CartProvider>(
            builder: (_, cart, __) => GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
              child: Container(
                width: 52, height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        color: AppColors.white, size: 24),
                    if (cart.itemCount > 0)
                      Positioned(
                        top: 6, right: 6,
                        child: Container(
                          width: 16, height: 16,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('${cart.itemCount}',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.textLight),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}