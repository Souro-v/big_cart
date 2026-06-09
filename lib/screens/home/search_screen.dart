import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/analytics_service.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/search_provider.dart';
import '../../services/product_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_routes.dart';
import '../../widgets/product_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/shimmer_loading.dart';

// যদি ActivityService এরর দেয়, তবে নিচের ইম্পোর্টটি আনকমেন্ট করে সঠিক পাথ বসাও:
// import '../../services/activity_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  List<String> _suggestions = [];

  final List<String> _discoverMore = [
    'Fresh Grocery',
    'Vegetables',
    'Fruits',
    'Beverages',
    'Household',
    'Edible oil',
    'Grocery',
    'Discount items',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() => _isSearching = query.isNotEmpty);
    context.read<ProductProvider>().search(query);

    // Suggestions fetch
    if (query.isNotEmpty) {
      ProductService().getSuggestions(query).then((suggestions) {
        if (mounted) setState(() => _suggestions = suggestions);
      });
    } else {
      setState(() => _suggestions = []);
    }
  }

  void _onTagTap(String tag) {
    _searchController.text = tag;
    _onSearch(tag);
    context.read<SearchProvider>().addToHistory(tag);
  }

  void _onSubmit(String query) {
    if (query.isNotEmpty) {
      context.read<SearchProvider>().addToHistory(query);
      AnalyticsService().logSearch(query);
      // Hide suggestions overlay when search is submitted
      setState(() => _suggestions = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().searchResults;
    final cart = context.watch<CartProvider>();
    final history = context.watch<SearchProvider>().history;
    final isSearching = context.watch<ProductProvider>().isSearching;

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
          onSubmitted: _onSubmit,
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
      body: Stack(
        children: [
          _isSearching
              ? isSearching
          // Loading shimmer
              ? Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 6,
              itemBuilder: (_, __) => const ProductCardShimmer(),
            ),
          )
              : products.isEmpty
              ? const EmptyState(
            icon: Icons.search_off_outlined,
            title: 'No results found!',
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
                    AppRoutes.productDetail, // তোমার রাউটের নাম আলাদা হলে চেঞ্জ করো
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
                      if (history.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Search History',
                              style: AppTextStyles.heading3,
                            ),
                            GestureDetector(
                              onTap: () => context
                                  .read<SearchProvider>()
                                  .clearHistory(),
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
                          children: history
                              .map(
                                (tag) => _SearchTag(
                              label: tag,
                              onTap: () => _onTagTap(tag),
                              onDelete: () => context
                                  .read<SearchProvider>()
                                  .removeItem(tag),
                            ),
                          )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Discover more
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discover more',
                            style: AppTextStyles.heading3,
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

          // Search Suggestions Overlay UI
          if (_suggestions.isNotEmpty && _isSearching)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _suggestions
                      .map((s) => ListTile(
                    leading: const Icon(Icons.search,
                        color: AppColors.textGrey, size: 18),
                    title: Text(s, style: AppTextStyles.bodyMedium),
                    trailing: const Icon(Icons.north_west,
                        color: AppColors.textGrey, size: 16),
                    onTap: () {
                      _searchController.text = s;
                      _onSearch(s);
                      _onSubmit(s);
                      setState(() => _suggestions = []);
                    },
                  ))
                      .toList(),
                ),
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
  final VoidCallback? onDelete;

  const _SearchTag({required this.label, required this.onTap, this.onDelete});

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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            if (onDelete != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}