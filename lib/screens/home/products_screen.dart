import 'package:big_cart/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/analytics_service.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String? _category;
  bool _loaded = false;

  String _sortLabel(SortOption option) {
    switch (option) {
      case SortOption.priceLowHigh:
        return 'Price: Low to High';
      case SortOption.priceHighLow:
        return 'Price: High to Low';
      case SortOption.newest:
        return 'Newest First';
      case SortOption.discount:
        return 'Best Discount';
      default:
        return '';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newCategory = ModalRoute
        .of(context)
        ?.settings
        .arguments as String?;
    if (!_loaded || _category != newCategory) {
      _category = newCategory;
      _loaded = true;
      AnalyticsService().logCategoryView(_category ?? 'All');
      Future.microtask(() {
        if (mounted) {
          final provider = context.read<ProductProvider>();
          if (provider.products.isEmpty) {
            provider.loadProducts().then((_) {
              if (mounted) {
                provider.selectCategory(_category ?? 'All');
              }
            });
          } else {
            provider.selectCategory(_category ?? 'All');
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final category = _category ?? 'All';
    final products = context
        .watch<ProductProvider>()
        .products;
    final isLoading = context
        .watch<ProductProvider>()
        .isLoading;
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark),
        ),
        title: Text(category, style: AppTextStyles.heading3),
        actions: [
          // Sort button
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort, color: AppColors.textDark),
            onSelected: (option) =>
                context.read<ProductProvider>().sortBy(option),
            itemBuilder: (_) =>
            [
              const PopupMenuItem(
                value: SortOption.none,
                child: Row(
                  children: [
                    Icon(Icons.clear_all, size: 20),
                    SizedBox(width: 8),
                    Text('Default'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.priceLowHigh,
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward, size: 20),
                    SizedBox(width: 8),
                    Text('Price: Low to High'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.priceHighLow,
                child: Row(
                  children: [
                    Icon(Icons.arrow_downward, size: 20),
                    SizedBox(width: 8),
                    Text('Price: High to Low'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.newest,
                child: Row(
                  children: [
                    Icon(Icons.new_releases_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Newest First'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.discount,
                child: Row(
                  children: [
                    Icon(Icons.local_offer_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Best Discount'),
                  ],
                ),
              ),
            ],
          ),
          // Filter button
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.textDark),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.filter),
          ),
        ],
        // AppBar এ bottom add করো
        bottom: context
            .watch<ProductProvider>()
            .sortOption != SortOption.none
            ? PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            color: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.sort,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  _sortLabel(context
                      .watch<ProductProvider>()
                      .sortOption),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () =>
                      context.read<ProductProvider>().clearSort(),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        )
            : null,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      )
          : products.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 80,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No products in $category',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
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
              quantity: qty,
              onAdd: () => cart.addToCart(p),
              onIncrease: () => cart.increaseQty(p.id),
              onDecrease: () => cart.decreaseQty(p.id),
              onTap: () =>
                  Navigator.pushNamed(
                    context,
                    AppRoutes.productDetail,
                    arguments: p,
                  ),
            );
          },
        ),
      ),
    );
  }
}
