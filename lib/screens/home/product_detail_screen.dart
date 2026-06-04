import 'package:big_cart/utils/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/product_model.dart';
import '../../providers/analytics_service.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/recently_viewed_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/haptic_helper.dart';
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
    HapticHelper.light();
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

  void _showImageZoom(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => _ImageZoomScreen(imageUrl: imageUrl),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _decrease() {
    HapticHelper.light();
    if (_quantity > 1) setState(() => _quantity--);
  }

  void _shareProduct(ProductModel product) {
    final discountedPrice = product.discount > 0
        ? product.price - (product.price * product.discount / 100)
        : product.price;

    final message =
        '''
🛒 Check out this product on Big Cart!

🏷️ ${product.name}
💰 \$${discountedPrice.toStringAsFixed(2)} ${product.discount > 0 ? '(${product.discount}% OFF!)' : ''}
📦 ${product.unit}

${product.description}

Download Big Cart app and get fresh groceries delivered to your doorstep! 🚀
''';

    Share.share(message);
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
          AnalyticsService().logProductView(product.id, product.name);
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
                  // Image area — light green background                  // Image area — light green background
                  GestureDetector(
                    onTap: () => _showImageZoom(context, product.imageUrl),
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      color: const Color(0xFFF2FAF4),
                      child: Stack(
                        children: [
                          Center(
                            child: AppImage(
                              url: product.imageUrl,
                              width: 220,
                              height: 220,
                              fit: BoxFit.contain,
                            ),
                          ),

                          // Zoom hint icon
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.8),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.zoom_in,
                                color: AppColors.textGrey,
                                size: 20,
                              ),
                            ),
                          ),

                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Back button
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      color: AppColors.textDark,
                                    ),
                                  ),

                                  // Share button
                                  IconButton(
                                    onPressed: () => _shareProduct(product),
                                    icon: const Icon(
                                      Icons.share_outlined,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                              onTap: () {
                                HapticHelper.light();
                                context.read<WishlistProvider>().toggle(
                                  product,
                                );
                              },
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
                                i < product.rating.floor()
                                    ? Icons.star
                                    : (i < product.rating
                                          ? Icons.star_half
                                          : Icons.star_border),
                                color: const Color(0xFFF3A93C),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${product.reviewCount} reviews)',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.writeReview,
                            arguments: product.id, // ← product id pass
                          ),
                          child: Text('Write Review'),
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
              text: !product.inStock
                  ? 'Out of Stock'
                  : inCart
                  ? 'Added to Cart ✓'
                  : 'Add to cart',
              onPressed: product.inStock
                  ? () {
                      HapticHelper.medium();

                      // Analytics Event
                      AnalyticsService().logAddToCart(
                        product.id,
                        product.name,
                        product.price,
                      );
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
                          margin: EdgeInsets.only(
                            bottom: 600,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                    }
                  : null, // ← null মানে disabled
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

class _ImageZoomScreen extends StatelessWidget {
  final String imageUrl;

  const _ImageZoomScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Zoomable image
          PhotoView(
            imageProvider: CachedNetworkImageProvider(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (_, __) => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),

          // Close button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
