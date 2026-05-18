import 'package:flutter/material.dart';
import 'dart:async';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/custom_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<String> _otp = List.filled(6, '');
  int _timerSeconds = 83; // 1:23
  Timer? _timer;
  bool _isPhoneStep = true; // true = phone input, false = otp input
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        t.cancel();
      }
    });
  }

  String get _timerText {
    final m = _timerSeconds ~/ 60;
    final s = _timerSeconds % 60;
    return '${m.toString().padLeft(1, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _onKeyPress(String value) {
    final filled = _otp.where((e) => e.isNotEmpty).length;
    if (value == 'del') {
      if (filled > 0) {
        setState(() => _otp[filled - 1] = '');
      }
    } else {
      if (filled < 6) {
        setState(() => _otp[filled] = value);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
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
        title: Text('Verify Number', style: AppTextStyles.heading3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            Text('Verify your number', style: AppTextStyles.heading2),
            const SizedBox(height: 12),
            Text(
              _isPhoneStep
                  ? 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy'
                  : 'Enter your OTP code below',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 32),

            // Phone input OR OTP boxes
            _isPhoneStep
                ? _PhoneInput(controller: _phoneController)
                : _OtpBoxes(otp: _otp),

            const SizedBox(height: 24),

            // Next button
            CustomButton(
              text: 'Next',
              onPressed: () {
                if (_isPhoneStep) {
                  setState(() => _isPhoneStep = false);
                } else {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                }
              },
            ),

            const SizedBox(height: 16),

            // Resend
            _isPhoneStep
                ? Text(
              'Resend confirmation code ($_timerText)',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textGrey,
              ),
            )
                : Column(
              children: [
                Text("Did'nt receive the code?",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => setState(() {
                    _timerSeconds = 83;
                    _startTimer();
                  }),
                  child: Text('Resend a new code',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Custom keypad
            _Keypad(onPress: _onKeyPress),
          ],
        ),
      ),
    );
  }
}

class _PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.none,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🇺🇸', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 4),
              Text('+1', style: AppTextStyles.bodyMedium),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        ),
        hintText: '2055550145',
      ),
    );
  }
}

class _OtpBoxes extends StatelessWidget {
  final List<String> otp;
  const _OtpBoxes({required this.otp});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (i) {
        final filled = otp[i].isNotEmpty;
        return Container(
          width: 44, height: 52,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: filled ? AppColors.primary : AppColors.border,
              width: filled ? 2 : 1,
            ),
          ),
          child: Center(
            child: filled
                ? Text(otp[i],
                style: AppTextStyles.heading3)
                : Container(
              width: 8, height: 8,
              decoration: const BoxDecoration(
                color: AppColors.textLight,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Keypad extends StatelessWidget {
  final Function(String) onPress;
  const _Keypad({required this.onPress});

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'del'],
    ];

    return Column(
      children: keys.map((row) => Row(
        children: row.map((key) => Expanded(
          child: GestureDetector(
            onTap: key.isEmpty ? null : () => onPress(key),
            child: Container(
              height: 56,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: key.isEmpty
                    ? Colors.transparent
                    : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: key.isEmpty
                    ? null
                    : Border.all(color: AppColors.border),
              ),
              child: Center(
                child: key == 'del'
                    ? const Icon(Icons.backspace_outlined,
                    color: AppColors.textDark, size: 22)
                    : Text(key,
                    style: AppTextStyles.heading3),
              ),
            ),
          ),
        )).toList(),
      )).toList(),
    );
  }
}