import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/app_image.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/error_snackbar.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  void _showCancelDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Cancel Order', style: AppTextStyles.heading3),
        content: Text(
          'Are you sure you want to cancel this order?',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context.read<OrderProvider>().cancelOrder(
                orderId,
              );
              if (success && context.mounted) {
                ErrorSnackbar.showSuccess(
                  context,
                  'Order cancelled successfully!',
                );
                Navigator.pop(context);
              } else if (context.mounted) {
                ErrorSnackbar.show(context, 'Failed to cancel order.');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Yes, Cancel', style: AppTextStyles.buttonText),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as OrderModel?;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: Text('Order Detail', style: AppTextStyles.heading3),
      ),
      body: order == null
          ? const Center(child: Text('Order not found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order #${order.id.substring(0, 5).toUpperCase()}',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Placed on ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            // Status badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(
                                  order.status,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                order.statusText,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: _statusColor(order.status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Delivery address
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delivery Address',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textGrey,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                order.address.isEmpty
                                    ? 'Default Address'
                                    : order.address,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Order items
                  Text('Order Items', style: AppTextStyles.heading3),
                  const SizedBox(height: 12),

                  order.items.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Center(
                            child: Text(
                              'No items',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: order.items.length,
                          itemBuilder: (_, i) {
                            final item = order.items[i];
                            return Container(
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
                                    borderRadius: BorderRadius.circular(12),
                                    child: AppImage(
                                      url: item.product.imageUrl,
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          item.product.unit,
                                          style: AppTextStyles.bodySmall,
                                        ),
                                        Text(
                                          'Qty: ${item.quantity}',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
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
                            );
                          },
                        ),

                  const SizedBox(height: 16),

                  // Price summary
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
                          value:
                              '\$${(order.totalAmount - 1.6).toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(label: 'Shipping', value: '\$1.60'),
                        const Divider(height: 20),
                        _SummaryRow(
                          label: 'Total',
                          value: '\$${order.totalAmount.toStringAsFixed(2)}',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Track order button
                  CustomButton(
                    text: 'Track Order',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.trackOrder,
                      arguments: {
                        'id': order.id.substring(0, 5).toUpperCase(),
                        'items': order.items.length,
                        'total': order.totalAmount.toStringAsFixed(2),
                      },
                    ),
                  ),
                  //only pending/confirmed order should be canceled
                  if (order.status == OrderStatus.pending ||
                      order.status == OrderStatus.confirmed) ...[
                    const SizedBox(height: 12),
                    CustomButton(
                      text: 'Cancel Order',
                      isOutlined: true,
                      onPressed: () => _showCancelDialog(context, order.id),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Write review button
                  CustomButton(
                    text: 'Write a Review',
                    isOutlined: true,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.writeReview),
                  ),
                ],
              ),
            ),
    );
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.confirmed:
        return AppColors.primary;
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
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
