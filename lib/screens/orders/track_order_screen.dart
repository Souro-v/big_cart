import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  String _getETA(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Estimated: 2-3 days';
      case OrderStatus.confirmed:
        return 'Estimated: 1-2 days';
      case OrderStatus.delivered:
        return 'Delivered ✅';
      case OrderStatus.cancelled:
        return 'Cancelled ❌';
    }
  }

  @override
  Widget build(BuildContext context) {
    final order =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final List<Map<String, dynamic>> steps = [
      {
        'title': 'Order Placed',
        'date': 'October 21 2021',
        'icon': Icons.inventory_2_outlined,
        'done': true,
      },
      {
        'title': 'Order Confirmed',
        'date': 'October 21 2021',
        'icon': Icons.check_circle_outline,
        'done': true,
      },
      {
        'title': 'Order Shipped',
        'date': 'October 21 2021',
        'icon': Icons.local_shipping_outlined,
        'done': true,
      },
      {
        'title': 'Out for Delivery',
        'date': 'Pending',
        'icon': Icons.directions_bike_outlined,
        'done': false,
      },
      {
        'title': 'Order Delivered',
        'date': 'Pending',
        'icon': Icons.shopping_cart_outlined,
        'done': false,
      },
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: Text('Track Order', style: AppTextStyles.heading3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Order summary card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order?['id'] ?? '90897'}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Placed on October 19 2021',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Items: ${order?['items'] ?? 10}  ',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Items: \$${order?['total'] ?? '16.90'}',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //Estimated time needed
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _getETA(order?['status'] ?? OrderStatus.pending),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tracking steps
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: ListView.builder(
                  itemCount: steps.length,
                  itemBuilder: (_, i) {
                    final step = steps[i];
                    final isLast = i == steps.length - 1;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon + line
                        Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: step['done']
                                    ? AppColors.primaryLight
                                    : AppColors.surface,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                step['icon'],
                                color: step['done']
                                    ? AppColors.primary
                                    : AppColors.textLight,
                                size: 24,
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 40,
                                color: step['done']
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                          ],
                        ),

                        const SizedBox(width: 16),

                        // Text
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step['title'],
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: step['done']
                                      ? AppColors.textDark
                                      : AppColors.textGrey,
                                ),
                              ),
                              Text(
                                step['date'],
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
