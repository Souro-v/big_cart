import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/app_image.dart';
import '../../widgets/custom_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark),
        ),
        title: Text('Shopping Cart', style: AppTextStyles.heading3),
      ),
      body: cart.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined,
                size: 80, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text('Your cart is empty',
                style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textGrey)),
          ],
        ),
      )
          : Column(
        children: [
          // Cart items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              itemBuilder: (_, i) {
                final item = cart.items[i];
                return _CartItem(
                  key: ValueKey(item.product.id),
                  item: item,
                  onIncrease: () =>
                      context.read<CartProvider>().increaseQty(item.product.id),
                  onDecrease: () =>
                      context.read<CartProvider>().decreaseQty(item.product.id),
                  onDelete: () =>
                      context.read<CartProvider>().removeFromCart(item.product.id),
                );
              },
            ),
          ),

          // Summary + Checkout
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: AppTextStyles.bodyMedium),
                    Text(
                      '\$${cart.totalAmount.toStringAsFixed(1)}',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping charges',
                        style: AppTextStyles.bodyMedium),
                    Text('\$1.6',
                        style: AppTextStyles.bodyMedium),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: AppTextStyles.heading3),
                    Text(
                      '\$${(cart.totalAmount + 1.6).toStringAsFixed(1)}',
                      style: AppTextStyles.heading3,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Checkout',
                  onPressed: () => Navigator.pushNamed(
                      context, AppRoutes.shippingMethod),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final dynamic item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;

  const _CartItem({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline,
            color: AppColors.white, size: 28),
      ),
      onDismissed: (_) => onDelete(),
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
                url: item.product.imageUrl,
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
                    '\$${item.product.price.toStringAsFixed(2)} x ${item.quantity}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(item.product.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold)),
                  Text(item.product.unit,
                      style: AppTextStyles.bodySmall),
                ],
              ),
            ),

            // Quantity control
            Column(
              children: [
                GestureDetector(
                  onTap: onIncrease,
                  child: const Icon(Icons.add,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(height: 8),
                Text('${item.quantity}',
                    style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onDecrease,
                  child: const Icon(Icons.remove,
                      color: AppColors.primary, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}