import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/analytics_service.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../services/activity_service.dart';
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
  // Added GlobalKey to validate the Form fields (Address validation)
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _notesController = TextEditingController();
  final _addressController = TextEditingController();
  bool _saveCard = true;
  int _selectedPayment = 1; // 0=Paypal, 1=Credit Card, 2=Apple Pay

  // Track the promo discount amount applied to the order
  double _promoDiscount = 0.0;

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _notesController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _makePayment() async {
    // Validate form before proceeding with payment
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    final orders = context.read<OrderProvider>();
    final address = _addressController.text.trim();

    // Calculate final total including delivery charge and deducting promo discount
    final total = cart.totalAmount + 1.6 - _promoDiscount;

    final success = await orders.placeOrder(
      userId: auth.user?.uid ?? '',
      items: cart.items,
      totalAmount: total,
      address: address,
      notes: _notesController.text.trim(),
    );

    if (success && mounted) {
      // Generated a unique orderId to pass into both Analytics and Activity log
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // Analytics Event with the updated final total
      AnalyticsService().logPurchase(
        orderId,
        total,
      );

      // Added Activity Log for Order Placement
      await ActivityService().log(
        userId: auth.user?.uid ?? '',
        action: 'order_placed',
        details: 'Order #$orderId - \$$total',
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
        title: const Text('Payment Method', style: AppTextStyles.heading3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        // Wrapped with Form widget to make validators work properly
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              _StepIndicator(),
              const SizedBox(height: 24),

              // Pass the callback to update the discount state in parent screen
              _PromoCode(
                onDiscountApplied: (discount) {
                  setState(() => _promoDiscount = discount);
                },
              ),
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
              const SizedBox(height: 16),
              const Text('Delivery Address', style: AppTextStyles.heading3),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController, // Activated here!
                decoration: const InputDecoration(
                  hintText: 'Enter your full address',
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: AppColors.textGrey,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const Text('Delivery Instructions',
                  style: AppTextStyles.heading3),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'e.g. Leave at door, Ring bell twice...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 40),
                    child: Icon(Icons.note_outlined, color: AppColors.textGrey),
                  ),
                  alignLabelWithHint: true,
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
                  prefixIcon: Icon(
                    Icons.credit_card,
                    color: AppColors.textGrey,
                  ),
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
                  const Text('Save this card', style: AppTextStyles.bodyMedium),
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
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _Step(number: 1, label: 'DELIVERY', done: true),
        _StepLine(),
        const _Step(number: 2, label: 'ADDRESS', done: true),
        _StepLine(),
        const _Step(number: 3, label: 'PAYMENT', done: false, isActive: true),
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
  // Callback parameter definition to notify parent about the calculated discount
  final Function(double discount) onDiscountApplied;

  const _PromoCode({required this.onDiscountApplied});

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
      final discountPercent = _promoCodes[code]!;

      // Calculate the discount amount based on the current cart total amount
      final cart = context.read<CartProvider>();
      final discountAmount = cart.totalAmount * discountPercent / 100;

      // Notify parent widget with the actual discount amount
      widget.onDiscountApplied(discountAmount);

      setState(() {
        _applied = true;
        _message = '$discountPercent% discount applied! 🎉';
      });
    } else {
      // Clear discount in parent state if an invalid code is typed
      widget.onDiscountApplied(0.0);

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
        const Text('Promo Code', style: AppTextStyles.heading3),
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
