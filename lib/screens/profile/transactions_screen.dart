import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  final List<Map<String, dynamic>> _transactions = const [
    {'type': 'mastercard', 'name': 'Master Card',  'date': 'Dec 12 2021 at 10:00 pm', 'amount': 89},
    {'type': 'visa',       'name': 'Master Card',  'date': 'Dec 12 2021 at 10:00 pm', 'amount': 109},
    {'type': 'paypal',     'name': 'Paypal',        'date': 'Dec 12 2021 at 10:00 pm', 'amount': 567},
    {'type': 'paypal',     'name': 'Paypal',        'date': 'Dec 12 2021 at 10:00 pm', 'amount': 567},
    {'type': 'visa',       'name': 'Master Card',  'date': 'Dec 12 2021 at 10:00 pm', 'amount': 109},
    {'type': 'mastercard', 'name': 'Master Card',  'date': 'Dec 12 2021 at 10:00 pm', 'amount': 89},
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
        title: Text('Transactions', style: AppTextStyles.heading3),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _transactions.length,
        itemBuilder: (_, i) {
          final t = _transactions[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                // Logo
                Container(
                  width: 48, height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: _CardLogo(type: t['type'])),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t['name'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(t['date'], style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),

                // Amount
                Text(
                  '\$${t['amount']}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CardLogo extends StatelessWidget {
  final String type;
  const _CardLogo({required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'visa':
        return Text('VISA',
          style: TextStyle(
            color: const Color(0xFF1A1F71),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        );
      case 'paypal':
        return const Icon(Icons.paypal, color: Color(0xFF003087), size: 28);
      default: // mastercard
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
}