import 'package:flutter/material.dart';
import '../../models/review_model.dart';
import '../../services/review_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_state.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId =
    ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: Text('Reviews', style: AppTextStyles.heading3),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.writeReview,
              arguments: productId,
            ),
            child: Text('Write',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<ReviewModel>>(
        future: ReviewService().getProductReviews(productId ?? ''),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return EmptyState(
              icon: Icons.rate_review_outlined,
              title: 'No reviews yet!',
              subtitle: 'Be the first to review this product.',
              buttonText: 'Write Review',
              onButtonTap: () => Navigator.pushNamed(
                context,
                AppRoutes.writeReview,
                arguments: productId,
              ),
            );
          }

          final reviews = snapshot.data!;

          // Rating summary
          final avgRating = reviews.fold<double>(
              0, (sum, r) => sum + r.rating) /
              reviews.length;

          return Column(
            children: [
              // Rating summary card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          avgRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (i) => Icon(
                            i < avgRating.floor()
                                ? Icons.star
                                : (i < avgRating
                                ? Icons.star_half
                                : Icons.star_border),
                            color: const Color(0xFFF3A93C),
                            size: 16,
                          )),
                        ),
                        Text('${reviews.length} reviews',
                            style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        children: List.generate(5, (i) {
                          final star = 5 - i;
                          final count = reviews
                              .where((r) => r.rating == star)
                              .length;
                          final percent = reviews.isEmpty
                              ? 0.0
                              : count / reviews.length;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Text('$star',
                                    style: AppTextStyles.bodySmall),
                                const SizedBox(width: 4),
                                const Icon(Icons.star,
                                    color: Color(0xFFF3A93C), size: 12),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: percent,
                                      backgroundColor: AppColors.border,
                                      valueColor:
                                      const AlwaysStoppedAnimation(
                                          Color(0xFFF3A93C)),
                                      minHeight: 8,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text('$count',
                                    style: AppTextStyles.bodySmall),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              // Reviews list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: reviews.length,
                  itemBuilder: (_, i) {
                    final review = reviews[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.primaryLight,
                                child: const Icon(Icons.person,
                                    color: AppColors.primary, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text('User',
                                      style: AppTextStyles.bodySmall
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: List.generate(5, (j) => Icon(
                                  j < review.rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: const Color(0xFFF3A93C),
                                  size: 14,
                                )),
                              ),
                            ],
                          ),
                          if (review.review.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(review.review,
                                style: AppTextStyles.bodySmall.copyWith(
                                  height: 1.5,
                                )),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Write review button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: CustomButton(
                  text: 'Write a Review',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.writeReview,
                    arguments: productId,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}