import 'package:big_cart/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newCategory = ModalRoute.of(context)?.settings.arguments as String?;
    if (!_loaded || _category != newCategory) {
      _category = newCategory;
      _loaded = true;
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
    final products = context.watch<ProductProvider>().products;
    final isLoading = context.watch<ProductProvider>().isLoading;
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
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.textDark),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.filter),
          ),
        ],
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
                    onTap: () => Navigator.pushNamed(
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
