import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/app_image.dart';
import '../../widgets/custom_button.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: const Text('Order Summary', style: AppTextStyles.heading3),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Items
                Text('Items (${cart.itemCount})',
                    style: AppTextStyles.heading3),
                const SizedBox(height: 12),
                ...cart.items.map((item) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AppImage(
                              url: item.product.imageUrl,
                              width: 56,
                              height: 56,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(item.product.unit,
                                    style: AppTextStyles.bodySmall),
                                Text(
                                  'Qty: ${item.quantity}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )),

                const SizedBox(height: 16),

                // Price breakdown
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(
                        label: 'Subtotal',
                        value: '\$${cart.totalAmount.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 8),
                      const _SummaryRow(
                        label: 'Shipping',
                        value: '\$1.60',
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'Tax (5%)',
                        value:
                            '\$${(cart.totalAmount * 0.05).toStringAsFixed(2)}',
                      ),
                      const Divider(height: 20),
                      _SummaryRow(
                        label: 'Total',
                        value:
                            '\$${(cart.totalAmount + 1.6 + cart.totalAmount * 0.05).toStringAsFixed(2)}',
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Proceed button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: CustomButton(
              text: 'Proceed to Checkout',
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.shippingMethod),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold ? AppTextStyles.heading3 : AppTextStyles.bodyMedium,
        ),
        Text(
          value,
          style: isBold ? AppTextStyles.heading3 : AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
