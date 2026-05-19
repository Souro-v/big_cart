import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/custom_button.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({super.key});

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  final _nameController    = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController    = TextEditingController();
  final _zipController     = TextEditingController();
  final _phoneController   = TextEditingController();
  String _selectedCountry  = 'United States';
  bool _makeDefault = true;
  int _selectedAddress = 0;

  final List<Map<String, dynamic>> _addresses = [
    {
      'name': 'Russell Austin',
      'address': '2811 Crescent Day, LA Port',
      'city': 'California, United States 77571',
      'phone': '+1 202 555 0142',
      'isDefault': true,
    },
    {
      'name': 'Jisca Simpson',
      'address': '2811 Crescent Day, LA Port',
      'city': 'California, United States 77571',
      'phone': '+1 202 555 0142',
      'isDefault': false,
    },
  ];

  final List<String> _countries = [
    'United States', 'United Kingdom',
    'Canada', 'Australia', 'Bangladesh', 'India',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
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
        title: Text('My Address', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saved addresses
            ..._addresses.asMap().entries.map((entry) {
              final i = entry.key;
              final addr = entry.value;
              return GestureDetector(
                onTap: () => setState(() => _selectedAddress = i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedAddress == i
                          ? AppColors.primary
                          : AppColors.border,
                      width: _selectedAddress == i ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (addr['isDefault'])
                        Text('DEFAULT',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (addr['isDefault'])
                        const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.location_on_outlined,
                                color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(addr['name'],
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(addr['address'],
                                    style: AppTextStyles.bodySmall),
                                Text(addr['city'],
                                    style: AppTextStyles.bodySmall),
                                Text(addr['phone'],
                                    style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                          Icon(
                            _selectedAddress == i
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 8),

            // Add new address form
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(hintText: 'Address'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(hintText: 'City'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _zipController,
                    decoration: const InputDecoration(hintText: 'Zip code'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Country
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
            const SizedBox(height: 12),

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: 'Phone number'),
            ),
            const SizedBox(height: 16),

            // Make default
            Row(
              children: [
                Switch(
                  value: _makeDefault,
                  onChanged: (v) => setState(() => _makeDefault = v),
                  activeThumbColor: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text('Make default', style: AppTextStyles.bodyMedium),
              ],
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Save settings',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}