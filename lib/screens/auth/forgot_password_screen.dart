import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendLink() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.forgotPassword(_emailController.text.trim());
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset link sent! Check your email.'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Failed to send link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: Text('Password Recovery', style: AppTextStyles.heading3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            Text('Forgot Password', style: AppTextStyles.heading2),
            const SizedBox(height: 12),
            Text(
              'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 32),

            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
                decoration: const InputDecoration(
                  hintText: 'Email Address',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Send link',
              onPressed: _sendLink,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
