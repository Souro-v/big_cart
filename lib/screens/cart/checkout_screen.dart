import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/analytics_service.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../services/order_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/error_snackbar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _saveCard = true;
  int _selectedPayment = 1; // 0=Paypal, 1=Credit Card, 2=Apple Pay

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _makePayment() async {
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    final orders = context.read<OrderProvider>();

    final success = await orders.placeOrder(
      userId: auth.user?.uid ?? '',
      items: cart.items,
      totalAmount: cart.totalAmount + 1.6,
      address: 'Default Address',
    );

    if (success && mounted) {
      // Analytics Event
      AnalyticsService().logPurchase(
        DateTime.now().millisecondsSinceEpoch.toString(), // orderId
        cart.totalAmount + 1.6,
      );
      await OrderService().addLoyaltyPoints(
        auth.user?.uid ?? '',
        cart.totalAmount,
      );
      cart.clearCart();
      Navigator.pushReplacementNamed(context, AppRoutes.orderSuccess);
    } else if (mounted) {
      ErrorSnackbar.show(context, orders.error ?? 'Payment failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<OrderProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: Text('Payment Method', style: AppTextStyles.heading3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            _StepIndicator(),
            const SizedBox(height: 24),
            _PromoCode(),
            const SizedBox(height: 20),
            // Payment options
            Row(
              children: [
                _PaymentOption(
                  icon: Icons.paypal,
                  label: 'Paypal',
                  selected: _selectedPayment == 0,
                  onTap: () => setState(() => _selectedPayment = 0),
                ),
                const SizedBox(width: 12),
                _PaymentOption(
                  icon: Icons.credit_card,
                  label: 'Credit Card',
                  selected: _selectedPayment == 1,
                  onTap: () => setState(() => _selectedPayment = 1),
                ),
                const SizedBox(width: 12),
                _PaymentOption(
                  icon: Icons.apple,
                  label: 'Apple pay',
                  selected: _selectedPayment == 2,
                  onTap: () => setState(() => _selectedPayment = 2),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Card preview
            Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Circles decoration
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    bottom: -30,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mastercard logo
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.8),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Card number
                      Text(
                        _cardController.text.isEmpty
                            ? 'XXXX  XXXX  XXXX  8790'
                            : _cardController.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CARD HOLDER',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                _nameController.text.isEmpty
                                    ? 'RUSSELL AUSTIN'
                                    : _nameController.text.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EXPIRES',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                _expiryController.text.isEmpty
                                    ? '01 / 22'
                                    : _expiryController.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Name on card
            TextFormField(
              controller: _nameController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Name on the card',
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: AppColors.textGrey,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Card number
            TextFormField(
              controller: _cardController,
              onChanged: (_) => setState(() {}),
              keyboardType: TextInputType.number,
              maxLength: 19,
              decoration: const InputDecoration(
                hintText: 'Card number',
                counterText: '',
                prefixIcon: Icon(Icons.credit_card, color: AppColors.textGrey),
              ),
            ),
            const SizedBox(height: 12),

            // Expiry + CVV
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    onChanged: (_) => setState(() {}),
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      hintText: 'Month / Year',
                      prefixIcon: Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 3,
                    decoration: const InputDecoration(
                      hintText: 'CVV',
                      counterText: '',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Save card
            Row(
              children: [
                Switch(
                  value: _saveCard,
                  onChanged: (v) => setState(() => _saveCard = v),
                  activeThumbColor: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text('Save this card', style: AppTextStyles.bodyMedium),
              ],
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Make payment',
              onPressed: _makePayment,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Step(number: 1, label: 'DELIVERY', done: true),
        _StepLine(),
        _Step(number: 2, label: 'ADDRESS', done: true),
        _StepLine(),
        _Step(number: 3, label: 'PAYMENT', done: false, isActive: true),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final int number;
  final String label;
  final bool done;
  final bool isActive;

  const _Step({
    required this.number,
    required this.label,
    this.done = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: done || isActive ? AppColors.primary : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: done || isActive ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    '$number',
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: done || isActive ? AppColors.primary : AppColors.textGrey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: AppColors.primary,
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? AppColors.primary : AppColors.textGrey,
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: selected ? AppColors.primary : AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoCode extends StatefulWidget {
  @override
  State<_PromoCode> createState() => _PromoCodeState();
}

class _PromoCodeState extends State<_PromoCode> {
  final _controller = TextEditingController();
  String? _message;
  bool _applied = false;

  // Valid promo codes
  final Map<String, int> _promoCodes = {
    'SAVE10': 10,
    'SAVE20': 20,
    'BIGCART': 15,
  };

  void _applyCode() {
    final code = _controller.text.trim().toUpperCase();
    if (_promoCodes.containsKey(code)) {
      setState(() {
        _applied = true;
        _message = '${_promoCodes[code]}% discount applied! 🎉';
      });
    } else {
      setState(() {
        _applied = false;
        _message = 'Invalid promo code!';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Promo Code', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  hintText: 'Enter promo code',
                  prefixIcon: Icon(
                    Icons.local_offer_outlined,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _applyCode,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Apply'),
            ),
          ],
        ),
        if (_message != null) ...[
          const SizedBox(height: 8),
          Text(
            _message!,
            style: AppTextStyles.bodySmall.copyWith(
              color: _applied ? AppColors.primary : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
