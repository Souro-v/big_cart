import 'package:big_cart/utils/app_routes.dart';
import 'package:big_cart/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final Set<String> _expanded = {};
  OrderStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final uid = context.read<AuthProvider>().user?.uid ?? '';
        context.read<OrderProvider>().listenToOrders(uid);
      }
    });
  }

  // Colorful Status Badge Helper Method
  Widget _statusBadge(OrderStatus status) {
    Color color;
    String text;
    switch (status) {
      case OrderStatus.pending:
        color = AppColors.warning;
        text = '⏳ Pending';
        break;
      case OrderStatus.confirmed:
        color = Colors.blue;
        text = '✅ Confirmed';
        break;
      case OrderStatus.delivered:
        color = AppColors.primary;
        text = '📦 Delivered';
        break;
      case OrderStatus.cancelled:
        color = AppColors.error;
        text = '❌ Cancelled';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders;
    final isLoading = context.watch<OrderProvider>().isLoading;
    final filteredOrders = _selectedStatus == null
        ? orders
        : orders.where((o) => o.status == _selectedStatus).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: const Text('My Order', style: AppTextStyles.heading3),
        actions: [
          PopupMenuButton<OrderStatus?>(
            icon: const Icon(Icons.tune, color: AppColors.textDark),
            onSelected: (status) => setState(() => _selectedStatus = status),
            itemBuilder: (_) => [
              const PopupMenuItem(value: null, child: Text('All Orders')),
              const PopupMenuItem(
                value: OrderStatus.pending,
                child: Text('Pending'),
              ),
              const PopupMenuItem(
                value: OrderStatus.confirmed,
                child: Text('Confirmed'),
              ),
              const PopupMenuItem(
                value: OrderStatus.delivered,
                child: Text('Delivered'),
              ),
              const PopupMenuItem(
                value: OrderStatus.cancelled,
                child: Text('Cancelled'),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      )
          : filteredOrders.isEmpty
          ? EmptyState(
        icon: Icons.shopping_bag_outlined,
        title: _selectedStatus == null
            ? 'No orders yet!'
            : 'No ${_selectedStatus!.name} orders!',
        subtitle: 'You have no orders in this category.',
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredOrders.length,
        itemBuilder: (_, i) {
          final order = filteredOrders[i];
          final isExpanded = _expanded.contains(order.id);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                // Order header
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.orderDetail,
                    arguments: order,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                            Icons.inventory_2_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order #${order.id.substring(0, 5).toUpperCase()}',
                                    style: AppTextStyles.bodyMedium
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Status Badge added here
                                  _statusBadge(order.status),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Placed on ${order.createdAt.day} ${_month(order.createdAt.month)} ${order.createdAt.year}',
                                style: AppTextStyles.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Items: ${order.items.length}  |  ',
                                    style: AppTextStyles.bodySmall
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                                    style: AppTextStyles.bodySmall
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => setState(() {
                            isExpanded
                                ? _expanded.remove(order.id)
                                : _expanded.add(order.id);
                          }),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                              ),
                            ),
                            child: Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Expanded tracking
                if (isExpanded) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _OrderTracking(order: order),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _month(int m) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[m];
  }
}

class _OrderTracking extends StatelessWidget {
  final OrderModel order;

  const _OrderTracking({required this.order});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'label': 'Order placed', 'done': true},
      {'label': 'Order confirmed', 'done': order.status != OrderStatus.pending},
      {'label': 'Order shipped', 'done': order.status == OrderStatus.delivered},
      {'label': 'Out for delivery', 'done': false},
      {
        'label': 'Order delivered',
        'done': order.status == OrderStatus.delivered,
      },
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final i = entry.key;
        final step = entry.value;
        final isLast = i == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dot + line
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: step['done'] == true
                        ? AppColors.primary
                        : AppColors.border,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 28,
                    color: step['done'] == true
                        ? AppColors.primary
                        : AppColors.border,
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Label + date
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      step['label'] as String,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: step['done'] == true
                            ? AppColors.textDark
                            : AppColors.textGrey,
                        fontWeight: step['done'] == true
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    Text(
                      step['done'] == true ? 'Oct ${19 + i} 2021' : 'pending',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}