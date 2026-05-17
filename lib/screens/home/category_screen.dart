import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../widgets/app_image.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Vegetables', 'image': AppAssets.catVegetables},
      {'name': 'Fruits', 'image': AppAssets.catFruits},
      {'name': 'Beverages', 'image': AppAssets.catBeverages},
      {'name': 'Grocery', 'image': AppAssets.catGrocery},
      {'name': 'Edible oil', 'image': AppAssets.catEdibleOil},
      {'name': 'Household', 'image': AppAssets.catHousehold},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark),
        ),
        title: Text('Categories', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.textDark),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.filter),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (_, i) => _CategoryCard(
            name: categories[i]['name']!,
            imageUrl: categories[i]['image']!,
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.category,
              arguments: categories[i]['name'],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: AppImage(
                url: imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
