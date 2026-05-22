import 'package:big_cart/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  final List<String> _searchHistory = [
    'Fresh Grocery',
    'Bananas',
    'cheetos',
    'vegetables',
    'Fruits',
    'discounted items',
    'Fresh vegetables',
  ];

  final List<String> _discoverMore = [
    'Fresh Grocery',
    'Bananas',
    'cheetos',
    'vegetables',
    'Fruits',
    'discounted items',
    'Fresh vegetables',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() => _isSearching = query.isNotEmpty);
    context.read<ProductProvider>().search(query);
  }

  void _onTagTap(String tag) {
    _searchController.text = tag;
    _onSearch(tag);
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().searchResults;
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: _onSearch,
          decoration: InputDecoration(
            hintText: 'Search keywords..',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
            prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
            suffixIcon: const Icon(Icons.tune, color: AppColors.textGrey),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
          ),
        ),
      ),
      body: _isSearching
          ? products.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off_outlined,
                    title: 'No result found!',
                    subtitle: 'Try searching with\ndifferent keywords.',
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        final p = products[i];
                        final qty = cart.isInCart(p.id)
                            ? cart.items
                                  .firstWhere((item) => item.product.id == p.id)
                                  .quantity
                            : 0;
                        return ProductCard(
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
                        );
                      },
                    ),
                  )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search History
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Search History',
                              style: AppTextStyles.heading3,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _searchHistory.clear()),
                              child: Text(
                                'clear',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _searchHistory
                              .map(
                                (tag) => _SearchTag(
                                  label: tag,
                                  onTap: () => _onTagTap(tag),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 24),

                        // Discover more
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Discover more',
                              style: AppTextStyles.heading3,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _discoverMore.clear()),
                              child: Text(
                                'clear',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _discoverMore
                              .map(
                                (tag) => _SearchTag(
                                  label: tag,
                                  onTap: () => _onTagTap(tag),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom buttons
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.textGrey,
                          ),
                          label: Text(
                            'Image Search',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.mic_outlined,
                            color: AppColors.textGrey,
                          ),
                          label: Text(
                            'Voice Search',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _SearchTag extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SearchTag({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(label, style: AppTextStyles.bodySmall),
      ),
    );
  }
}
