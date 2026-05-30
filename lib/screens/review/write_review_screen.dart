import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/review_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/review_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/custom_button.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _rating = 0;
  final _reviewController = TextEditingController();
  bool _isLoading = false;
  final ReviewService _reviewService = ReviewService();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    final productId = ModalRoute.of(context)?.settings.arguments as String?;

    try {
      await _reviewService.addReview(
        ReviewModel(
          id: '',
          userId: auth.user?.uid ?? '',
          productId: productId ?? '',
          rating: _rating,
          review: _reviewController.text.trim(),
          createdAt: DateTime.now(),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review submitted! Thank you 🎉'),
            backgroundColor: AppColors.primary,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
        title: Text('Write Reviews', style: AppTextStyles.heading3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            Text('What do you think?', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text(
              'please give your rating by clicking on\nthe stars below',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 32),

            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFF3A93C),
                    size: 40,
                  ),
                ),
              )),
            ),

            const SizedBox(height: 32),

            // Review text
            TextFormField(
              controller: _reviewController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Tell us about your experience',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 60),
                  child: Icon(Icons.edit_outlined,
                      color: AppColors.textGrey),
                ),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 32),

            CustomButton(
              text: 'Submit Review',
              onPressed: _submitReview,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}