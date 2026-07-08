import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/step_indicator.dart';

class ShippingMethodScreen extends StatefulWidget {
  const ShippingMethodScreen({super.key});

  @override
  State<ShippingMethodScreen> createState() => _ShippingMethodScreenState();
}

class _ShippingMethodScreenState extends State<ShippingMethodScreen> {
  int _selected = 0;

  final List<Map<String, dynamic>> _methods = [
    {
      'title': 'Standard Delivery',
      'desc':
          'Order will be delivered between 3 - 4 business days straights to your doorstep.',
      'price': 3,
    },
    {
      'title': 'Next Day Delivery',
      'desc':
          'Order will be delivered between 3 - 4 business days straights to your doorstep.',
      'price': 5,
    },
    {
      'title': 'Nominated Delivery',
      'desc':
          'Order will be delivered between 3 - 4 business days straights to your doorstep.',
      'price': 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: const Text('Shipping Method', style: AppTextStyles.heading3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Step indicator
           const StepIndicator(currentStep: 1),
            const SizedBox(height: 24),

            // Delivery options
            Expanded(
              child: ListView.builder(
                itemCount: _methods.length,
                itemBuilder: (_, i) => _DeliveryCard(
                  title: _methods[i]['title'],
                  desc: _methods[i]['desc'],
                  price: _methods[i]['price'],
                  selected: _selected == i,
                  onTap: () => setState(() => _selected = i),
                ),
              ),
            ),

            CustomButton(
              text: 'Next',
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.shippingAddress,
                arguments: _methods[_selected]['price'],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final String title;
  final String desc;
  final int price;
  final bool selected;
  final VoidCallback onTap;

  const _DeliveryCard({
    required this.title,
    required this.desc,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '\$$price',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
