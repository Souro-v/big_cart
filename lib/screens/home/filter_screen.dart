import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/custom_button.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int _selectedRating = 4;
  bool _discount = true;
  bool _freeShipping = true;
  bool _sameDayDelivery = true;
  RangeValues _priceRange = const RangeValues(0, 100);
  static const double _maxPriceLimit = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark),
        ),
        title: const Text('Apply Filters', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textDark),
            onPressed: () => setState(() {
              _priceRange = const RangeValues(0, 100);
              _selectedRating = 0;
              _discount = false;
              _freeShipping = false;
              _sameDayDelivery = false;
              context.read<ProductProvider>().clearFilter();
            }),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price Range
            const Text('Price Range', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${_priceRange.start.toStringAsFixed(0)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${_priceRange.end.toStringAsFixed(0)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: _maxPriceLimit,
                    divisions: 20,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.border,
                    onChanged: (values) => setState(() => _priceRange = values),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Star Rating
            const Text('Star Rating', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  ...List.generate(
                    5,
                        (i) => GestureDetector(
                      onTap: () => setState(() => _selectedRating = i + 1),
                      child: Icon(
                        i < _selectedRating ? Icons.star : Icons.star_border,
                        color: const Color(0xFFF3A93C),
                        size: 28,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$_selectedRating stars',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Others
            const Text('Others', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _FilterOption(
                    icon: Icons.local_offer_outlined,
                    label: 'Discount',
                    value: _discount,
                    onChanged: (v) => setState(() => _discount = v),
                  ),
                  const Divider(height: 1),
                  _FilterOption(
                    icon: Icons.local_shipping_outlined,
                    label: 'Free shipping',
                    value: _freeShipping,
                    onChanged: (v) => setState(() => _freeShipping = v),
                  ),
                  const Divider(height: 1),
                  _FilterOption(
                    icon: Icons.inventory_2_outlined,
                    label: 'Same day delivery',
                    value: _sameDayDelivery,
                    onChanged: (v) => setState(() => _sameDayDelivery = v),
                  ),
                ],
              ),
            ),

            const Spacer(),

            CustomButton(
              text: 'Apply filter',
              onPressed: () {
                context.read<ProductProvider>().applyFilter(
                  minPrice: _priceRange.start > 0 ? _priceRange.start : null,
                  maxPrice: _priceRange.end < _maxPriceLimit
                      ? _priceRange.end
                      : null,
                  minRating: _selectedRating > 0 ? _selectedRating : null,
                  hasDiscount: _discount,
                  freeShipping: _freeShipping,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _FilterOption({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textGrey, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Icon(
              value ? Icons.check_circle_outline : Icons.radio_button_unchecked,
              color: value ? AppColors.primary : AppColors.textLight,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}