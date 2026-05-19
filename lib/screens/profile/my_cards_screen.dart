import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/custom_button.dart';

class MyCardsScreen extends StatefulWidget {
  const MyCardsScreen({super.key});

  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  int _selectedCard = 0;

  final List<Map<String, dynamic>> _cards = [
    {
      'type': 'Master Card',
      'number': 'XXXX XXXX XXXX 5678',
      'expiry': '01/22',
      'cvv': '908',
      'isDefault': true,
      'isVisa': false,
    },
    {
      'type': 'Visa Card',
      'number': 'XXXX XXXX XXXX 5678',
      'expiry': '01/22',
      'cvv': '908',
      'isDefault': false,
      'isVisa': true,
    },
    {
      'type': 'Master Card',
      'number': 'XXXX XXXX XXXX 5678',
      'expiry': '01/22',
      'cvv': '908',
      'isDefault': false,
      'isVisa': false,
    },
  ];

  final _nameController   = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController    = TextEditingController();
  bool _makeDefault = true;

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
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
        title: Text('My Cards', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: AppColors.textDark),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.addCard),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Cards list
            ..._cards.asMap().entries.map((entry) {
              final i    = entry.key;
              final card = entry.value;
              final isExpanded = _selectedCard == i;

              return GestureDetector(
                onTap: () => setState(() => _selectedCard = i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isExpanded
                          ? AppColors.primary
                          : AppColors.border,
                      width: isExpanded ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Card logo
                            Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: card['isVisa']
                                    ? Text('VISA',
                                    style: TextStyle(
                                      color: const Color(0xFF1A1F71),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ))
                                    : _MasterCardLogo(),
                              ),
                            ),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (card['isDefault'])
                                    Text('DEFAULT',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  Text(card['type'],
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(card['number'],
                                      style: AppTextStyles.bodySmall),
                                  Text(
                                    'Expiry : ${card['expiry']}  CVV : ${card['cvv']}',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: 28, height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Expanded edit form
                      if (isExpanded) ...[
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  hintText: 'Russell Austin',
                                  prefixIcon: Icon(Icons.person_outline,
                                      color: AppColors.textGrey),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _numberController,
                                decoration: const InputDecoration(
                                  hintText: 'XXXX XXXX XXXX 5678',
                                  prefixIcon: Icon(Icons.credit_card,
                                      color: AppColors.textGrey),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _expiryController,
                                      decoration: const InputDecoration(
                                        hintText: '01/22',
                                        prefixIcon: Icon(
                                            Icons.calendar_today_outlined,
                                            color: AppColors.textGrey),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _cvvController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        hintText: '908',
                                        prefixIcon: Icon(Icons.lock_outline,
                                            color: AppColors.textGrey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Switch(
                                    value: _makeDefault,
                                    onChanged: (v) =>
                                        setState(() => _makeDefault = v),
                                    activeThumbColor: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text('Make default',
                                      style: AppTextStyles.bodyMedium),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),

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

class _MasterCardLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32, height: 20,
      child: Stack(
        children: [
          Container(
            width: 20, height: 20,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            left: 12,
            child: Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}