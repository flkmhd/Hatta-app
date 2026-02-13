import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../shared/widgets/header.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../data/products_service.dart';
import '../../domain/models/product.dart';
import '../widgets/trending_tags.dart';
import 'product_detail_page.dart';

/// Home Feed Page matching React's HomeFeed.tsx
class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({super.key});

  @override
  State<HomeFeedPage> createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  final ProductsService _productsService = ProductsService();
  bool _isLoading = true;
  List<Product> _products = [];
  Product? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _productsService.fetchLatestProducts();
      if (!mounted) return;
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Failed to load products: $error');
      if (!mounted) return;
      setState(() {
        _products = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Stack(
      children: [
        // Main feed
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            top: false,
            child: CustomScrollView(
              slivers: [
                // Padding for safe area
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).padding.top),
                ),

                // Header
                const SliverToBoxAdapter(child: AppHeader()),

                // Padding after header
                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Trending Tags
                const SliverToBoxAdapter(child: TrendingTags()),

                // Feed Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.translate('home.title') ??
                              'Zahi dressing-tou ✨',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n?.translate('home.subtitle') ??
                              'Les dernières pépites près de chez toi',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.mutedForeground),
                        ),
                      ],
                    ),
                  ),
                ),

                // Product Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: _buildProductGrid(),
                ),

                // Bottom padding for navigation
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),

        // Product Detail Overlay
        if (_selectedProduct != null)
          ProductDetailPage(
            product: _selectedProduct!,
            onBack: () {
              setState(() {
                _selectedProduct = null;
              });
            },
          ),
      ],
    );
  }

  Widget _buildProductGrid() {
    if (_isLoading) {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getColumnCount(context),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.58,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const ProductCardSkeleton(),
          childCount: 8,
        ),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getColumnCount(context),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.58,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final product = _products[index];
        return ProductCard(
          product: product,
          onTap: () {
            setState(() {
              _selectedProduct = product;
            });
            // TODO: Show product detail bottom sheet
          },
        );
      }, childCount: _products.length),
    );
  }

  /// Get column count based on screen width (matching React's responsive cols)
  int _getColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1280) return 6; // xl
    if (width >= 1024) return 5; // lg
    if (width >= 768) return 4; // md
    if (width >= 640) return 3; // sm
    return 2; // default
  }
}
