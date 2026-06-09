import 'package:big_cart/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/app_image.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/error_snackbar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNavBar(currentTab: NavTab.wishlist),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: Text('Favorites', style: AppTextStyles.heading3),
        // AppBar action
        actions: [
          if (!wishlist.isEmpty)
            TextButton(
              onPressed: () {
                final cart = context.read<CartProvider>();
                for (final product in wishlist.items) {
                  cart.addToCart(product);
                }
                ErrorSnackbar.showSuccess(
                  context,
                  '${wishlist.count} items added to cart!',
                );
              },
              child: Text(
                'Add All',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: wishlist.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border,
              title: 'No favourite yet!',
              subtitle: 'Save your favourite products\nhere for easy access',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wishlist.items.length,
              itemBuilder: (_, i) {
                final product = wishlist.items[i];
                final qty = cart.isInCart(product.id)
                    ? cart.items
                          .firstWhere((item) => item.product.id == product.id)
                          .quantity
                    : 0;

                return Dismissible(
                  key: ValueKey(product.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                  onDismissed: (_) =>
                      context.read<WishlistProvider>().remove(product.id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AppImage(
                            url: product.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)} x $qty',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product.name,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                product.unit,
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),

                        // Quantity control
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => cart.addToCart(product),
                              child: const Icon(
                                Icons.add,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$qty',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => cart.decreaseQty(product.id),
                              child: const Icon(
                                Icons.remove,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
