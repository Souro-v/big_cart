import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/address_provider.dart';
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _saveAddress = true;
  String _selectedCountry = 'United States';

  final List<String> _countries = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Bangladesh',
    'India',
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
    final addressProvider = context.watch<AddressProvider>();
    final savedAddresses = addressProvider.addresses;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: const Text('Shipping Address', style: AppTextStyles.heading3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Step indicator
            const  StepIndicator(currentStep: 2),
              const SizedBox(height: 24),

              if (savedAddresses.isNotEmpty) ...[
               const Text('Saved Addresses', style: AppTextStyles.heading3),
                const SizedBox(height: 12),
                ...savedAddresses.map(
                  (addr) => GestureDetector(
                    onTap: () {
                      addressProvider.selectAddress(addr);
                      // Form fields fill করো
                      _nameController.text = addr.name;
                      _addressController.text = addr.address;
                      _cityController.text = addr.city;
                      _zipController.text = addr.zip;
                      _phoneController.text = addr.phone;
                      setState(() => _selectedCountry = addr.country);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: addressProvider.selectedAddress == addr
                              ? AppColors.primary
                              : AppColors.border,
                          width: addressProvider.selectedAddress == addr
                              ? 2
                              : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  addr.name,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  addr.fullAddress,
                                  style: AppTextStyles.bodySmall,
                                ),
                                Text(
                                  addr.phone,
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          if (addr.isDefault)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Default',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 24),
               const  Text('Add New Address', style: AppTextStyles.heading3),
                const SizedBox(height: 12),
              ],
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email address',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Phone number',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: 'Address',
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Zip code
              TextFormField(
                controller: _zipController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Zip code',
                  prefixIcon: Icon(
                    Icons.grid_view_outlined,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // City
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  hintText: 'City',
                  prefixIcon: Icon(
                    Icons.map_outlined,
                    color: AppColors.textGrey,
                  ),
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
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.textGrey,
                    ),
                    items: _countries
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.language,
                                  color: AppColors.textGrey,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(c, style: AppTextStyles.bodyMedium),
                              ],
                            ),
                          ),
                        )
                        .toList(),
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
                const  Text('Save this address', style: AppTextStyles.bodyMedium),
                ],
              ),

              const SizedBox(height: 24),

              CustomButton(
                text: 'Next',
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  // Address save করো
                  final newAddress = AddressModel(
                    name: _nameController.text.trim(),
                    address: _addressController.text.trim(),
                    city: _cityController.text.trim(),
                    zip: _zipController.text.trim(),
                    country: _selectedCountry,
                    phone: _phoneController.text.trim(),
                    isDefault: _saveAddress,
                  );

                  if (_saveAddress) {
                    context.read<AddressProvider>().addAddress(newAddress);
                  }

                  Navigator.pushNamed(
                    context,
                    AppRoutes.checkout,
                    arguments:
                        '${_addressController.text}, ${_cityController.text}',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
