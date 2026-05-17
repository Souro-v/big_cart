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
  final Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    final category = ModalRoute.of(context)!.settings.arguments as String?;
    Future.microtask(() {
      if (category != null) {
        context.read<ProductProvider>().selectCategory(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as String? ?? 'All';
    final products  = context.watch<ProductProvider>().products;
    final isLoading = context.watch<ProductProvider>().isLoading;
    final cart      = context.watch<CartProvider>();

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
            onPressed: (){},
          ),
        ],
      ),
      body: isLoading
          ? const Center(
          child: CircularProgressIndicator(color: AppColors.primary))
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