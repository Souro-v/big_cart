import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/custom_button.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  int _selectedRating = 4;
  bool _discount      = true;
  bool _freeShipping  = true;
  bool _sameDayDelivery = true;

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark),
        ),
        title: Text('Apply Filters', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textDark),
            onPressed: () => setState(() {
              _minController.clear();
              _maxController.clear();
              _selectedRating  = 4;
              _discount        = true;
              _freeShipping    = true;
              _sameDayDelivery = true;
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
            Text('Price Range', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Min.'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Max.'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Star Rating
            Text('Star Rating', style: AppTextStyles.heading3),
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
                  ...List.generate(5, (i) => GestureDetector(
                    onTap: () => setState(() => _selectedRating = i + 1),
                    child: Icon(
                      i < _selectedRating ? Icons.star : Icons.star_border,
                      color: const Color(0xFFF3A93C),
                      size: 28,
                    ),
                  )),
                  const Spacer(),
                  Text('$_selectedRating stars',
                      style: AppTextStyles.bodySmall),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Others
            Text('Others', style: AppTextStyles.heading3),
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
              onPressed: () => Navigator.pop(context),
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
          Expanded(
            child: Text(label, style: AppTextStyles.bodyMedium),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Icon(
              value
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
              color: value ? AppColors.primary : AppColors.textLight,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}