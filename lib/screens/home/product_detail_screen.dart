import 'package:big_cart/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/recently_viewed_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/app_image.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/product_card.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _showFullDescription = false;

  void _increase() {
    if (_quantity < CartProvider.maxQty) {
      setState(() => _quantity++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 10 items allowed!'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 600, left: 16, right: 16),
        ),
      );
    }
  }

  void _decrease() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  bool _added = false;

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductModel;
    final cart = context.watch<CartProvider>();
    final inCart = cart.isInCart(product.id);
    final wishlist = context.watch<WishlistProvider>();
    final isFav = wishlist.isWishlisted(product.id);

    if (!_added) {
      _added = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<RecentlyViewedProvider>().add(product);
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image area — light green background
                  Container(
                    width: double.infinity,
                    height: 300,
                    color: const Color(0xFFF2FAF4),
                    child: Stack(
                      children: [
                        // Product image
                        Center(
                          child: AppImage(
                            url: product.imageUrl,
                            width: 220,
                            height: 220,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Back button
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Details
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price + Favorite
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: AppTextStyles.heading2.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context
                                  .read<WishlistProvider>()
                                  .toggle(product),
                              child: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav
                                    ? AppColors.error
                                    : AppColors.textLight,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Name
                        Text(product.name, style: AppTextStyles.heading2),

                        const SizedBox(height: 4),

                        // Unit
                        Text(product.unit, style: AppTextStyles.bodySmall),

                        const SizedBox(height: 12),

                        // Rating
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (i) => Icon(
                                i < 4 ? Icons.star : Icons.star_half,
                                color: const Color(0xFFF3A93C),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '4.5',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(89 reviews)',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.writeReview,
                          ),
                          child: Text(
                            'Write Review',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Description
                        GestureDetector(
                          onTap: () => setState(
                            () => _showFullDescription = !_showFullDescription,
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textGrey,
                                height: 1.6,
                              ),
                              children: [
                                TextSpan(
                                  text: _showFullDescription
                                      ? product.description
                                      : product.description.length > 120
                                      ? '${product.description.substring(0, 120)}... '
                                      : product.description,
                                ),
                                if (product.description.length > 120)
                                  TextSpan(
                                    text: _showFullDescription
                                        ? ' less'
                                        : 'more',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Quantity
                        Row(
                          children: [
                            Text('Quantity', style: AppTextStyles.bodyLarge),
                            const Spacer(),
                            _QtyButton(icon: Icons.remove, onTap: _decrease),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                '$_quantity',
                                style: AppTextStyles.heading3,
                              ),
                            ),
                            _QtyButton(icon: Icons.add, onTap: _increase),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Related Products
                        _RelatedProducts(
                          category: product.category,
                          excludeId: product.id,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add to cart button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: CustomButton(
              text: inCart ? 'Added to Cart ✓' : 'Add to cart',
              onPressed: () {
                final cart = context.read<CartProvider>();
                for (int i = 0; i < _quantity; i++) {
                  cart.addToCart(product);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Added 🥰'),
                    duration: Duration(seconds: 2),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 600, left: 16, right: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.textDark),
      ),
    );
  }
}

class _RelatedProducts extends StatelessWidget {
  final String category;
  final String excludeId;

  const _RelatedProducts({required this.category, required this.excludeId});

  @override
  Widget build(BuildContext context) {
    final related = context.watch<ProductProvider>().getRelated(
      category,
      excludeId,
    );
    final cart = context.watch<CartProvider>();

    if (related.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Related Products', style: AppTextStyles.heading3),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: related.length,
            itemBuilder: (_, i) {
              final p = related[i];
              final qty = cart.isInCart(p.id)
                  ? cart.items
                        .firstWhere((item) => item.product.id == p.id)
                        .quantity
                  : 0;
              return SizedBox(
                width: 160,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ProductCard(
                    product: p,
                    quantity: qty,
                    onAdd: () => cart.addToCart(p),
                    onIncrease: () => cart.increaseQty(p.id),
                    onDecrease: () => cart.decreaseQty(p.id),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.productDetail,
                      arguments: p,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
