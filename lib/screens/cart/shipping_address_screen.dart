import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/step_indicator.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final _nameController    = TextEditingController();
  final _emailController   = TextEditingController();
  final _phoneController   = TextEditingController();
  final _addressController = TextEditingController();
  final _zipController     = TextEditingController();
  final _cityController    = TextEditingController();
  bool _saveAddress = true;
  String _selectedCountry = 'United States';

  final List<String> _countries = [
    'United States', 'United Kingdom', 'Canada',
    'Australia', 'Bangladesh', 'India',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _zipController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: Text('Shipping Address', style: AppTextStyles.heading3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Step indicator
            StepIndicator(currentStep: 2),
            const SizedBox(height: 24),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Name',
                prefixIcon: Icon(Icons.person_outline,
                    color: AppColors.textGrey),
              ),
            ),
            const SizedBox(height: 12),

            // Email
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email address',
                prefixIcon: Icon(Icons.email_outlined,
                    color: AppColors.textGrey),
              ),
            ),
            const SizedBox(height: 12),

            // Phone
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Phone number',
                prefixIcon: Icon(Icons.phone_outlined,
                    color: AppColors.textGrey),
              ),
            ),
            const SizedBox(height: 12),

            // Address
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                hintText: 'Address',
                prefixIcon: Icon(Icons.location_on_outlined,
                    color: AppColors.textGrey),
              ),
            ),
            const SizedBox(height: 12),

            // Zip code
            TextFormField(
              controller: _zipController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Zip code',
                prefixIcon: Icon(Icons.grid_view_outlined,
                    color: AppColors.textGrey),
              ),
            ),
            const SizedBox(height: 12),

            // City
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                hintText: 'City',
                prefixIcon: Icon(Icons.map_outlined,
                    color: AppColors.textGrey),
              ),
            ),
            const SizedBox(height: 12),

            // Country dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCountry,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down,
                      color: AppColors.textGrey),
                  items: _countries.map((c) => DropdownMenuItem(
                    value: c,
                    child: Row(
                      children: [
                        const Icon(Icons.language,
                            color: AppColors.textGrey, size: 20),
                        const SizedBox(width: 12),
                        Text(c, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  )).toList(),
                  onChanged: (v) => setState(() => _selectedCountry = v!),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Save address
            Row(
              children: [
                Switch(
                  value: _saveAddress,
                  onChanged: (v) => setState(() => _saveAddress = v),
                  activeThumbColor: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text('Save this address', style: AppTextStyles.bodyMedium),
              ],
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Next',
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.checkout,
                arguments: _addressController.text.isEmpty
                    ? 'Default Address'
                    : '${_addressController.text}, ${_cityController.text}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}