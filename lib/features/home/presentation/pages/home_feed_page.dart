import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../shared/widgets/header.dart';
import '../../../../shared/widgets/product_card.dart';
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
  bool _isLoading = true;
  List<Product> _products = [];
  Product? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Replace with actual Supabase fetch
    setState(() {
      _products = _getMockProducts();
      _isLoading = false;
    });
  }

  List<Product> _getMockProducts() {
    return [
      Product(
        id: '1',
        image:
            'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=400&q=80',
        title: 'Caftan moderne brodé main',
        description: 'Caftan traditionnel avec broderie artisanale',
        price: 35000,
        size: 'M',
        condition: ProductCondition.neuf,
        category: 'Traditionnel',
        location: 'Alger Centre',
        wilaya: 'Alger',
        isLocalPickup: true,
        sellerVerified: true,
        seller: const Seller(
          name: 'Amina',
          avatar:
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
          rating: 4.9,
          reviewCount: 127,
        ),
        images: [
          'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=400&q=80',
        ],
      ),
      Product(
        id: '2',
        image:
            'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=400&q=80',
        title: 'Veste vintage cuir années 90',
        description: 'Veste en cuir véritable vintage',
        price: 12000,
        size: 'L',
        condition: ProductCondition.tresBon,
        category: 'Vêtements',
        location: 'Oran',
        wilaya: 'Oran',
        isLocalPickup: false,
        sellerVerified: true,
        seller: const Seller(
          name: 'Sara',
          avatar:
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
          rating: 4.8,
          reviewCount: 89,
        ),
        images: [
          'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=400&q=80',
        ],
      ),
      Product(
        id: '3',
        image:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80',
        title: 'Nike Air Max 90 - État neuf',
        description: 'Baskets Nike Air Max 90 en parfait état',
        price: 18500,
        size: '42',
        condition: ProductCondition.neuf,
        category: 'Chaussures',
        location: 'Constantine',
        wilaya: 'Constantine',
        isLocalPickup: true,
        sellerVerified: false,
        seller: const Seller(
          name: 'Yacine',
          avatar:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
          rating: 4.7,
          reviewCount: 56,
        ),
        images: [
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80',
        ],
      ),
      Product(
        id: '4',
        image:
            'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400&q=80',
        title: 'Robe d\'été fleurie',
        description: 'Robe légère parfaite pour l\'été',
        price: 4500,
        size: 'S',
        condition: ProductCondition.tresBon,
        category: 'Vêtements',
        location: 'Annaba',
        wilaya: 'Annaba',
        isLocalPickup: false,
        sellerVerified: true,
        seller: const Seller(
          name: 'Lina',
          avatar:
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&q=80',
          rating: 5.0,
          reviewCount: 203,
        ),
        images: [
          'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400&q=80',
        ],
      ),
      Product(
        id: '5',
        image:
            'https://images.unsplash.com/photo-1588117305388-c2631a279f82?w=400&q=80',
        title: 'Hoodie streetwear oversize',
        description: 'Hoodie oversize style streetwear',
        price: 6500,
        size: 'XL',
        condition: ProductCondition.bon,
        category: 'Vêtements',
        location: 'Blida',
        wilaya: 'Blida',
        isLocalPickup: true,
        sellerVerified: false,
        seller: const Seller(
          name: 'Karim',
          avatar:
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&q=80',
          rating: 4.6,
          reviewCount: 42,
        ),
        images: [
          'https://images.unsplash.com/photo-1588117305388-c2631a279f82?w=400&q=80',
        ],
      ),
      Product(
        id: '6',
        image:
            'https://images.unsplash.com/photo-1591561954557-26941169b49e?w=400&q=80',
        title: 'Karakou moderne rose',
        description: 'Ensemble karakou moderne avec broderie',
        price: 45000,
        size: 'M',
        condition: ProductCondition.neuf,
        category: 'Traditionnel',
        location: 'Tlemcen',
        wilaya: 'Tlemcen',
        isLocalPickup: false,
        sellerVerified: true,
        seller: const Seller(
          name: 'Fatima',
          avatar:
              'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=100&q=80',
          rating: 4.9,
          reviewCount: 156,
        ),
        images: [
          'https://images.unsplash.com/photo-1591561954557-26941169b49e?w=400&q=80',
        ],
      ),
      Product(
        id: '7',
        image:
            'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&q=80',
        title: 'Sac à main cuir camel',
        description: 'Sac en cuir véritable couleur camel',
        price: 8900,
        size: 'Unique',
        condition: ProductCondition.tresBon,
        category: 'Accessoires',
        location: 'Sétif',
        wilaya: 'Sétif',
        isLocalPickup: true,
        sellerVerified: true,
        seller: const Seller(
          name: 'Meriem',
          avatar:
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&q=80',
          rating: 4.8,
          reviewCount: 78,
        ),
        images: [
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&q=80',
        ],
      ),
      Product(
        id: '8',
        image:
            'https://images.unsplash.com/photo-1565084888279-aca607ecce0c?w=400&q=80',
        title: 'Jean slim Levi\'s 501',
        description: 'Jean Levi\'s 501 original',
        price: 7500,
        size: '38',
        condition: ProductCondition.bon,
        category: 'Vêtements',
        location: 'Béjaïa',
        wilaya: 'Béjaïa',
        isLocalPickup: false,
        sellerVerified: false,
        seller: const Seller(
          name: 'Amine',
          avatar:
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
          rating: 4.5,
          reviewCount: 34,
        ),
        images: [
          'https://images.unsplash.com/photo-1565084888279-aca607ecce0c?w=400&q=80',
        ],
      ),
    ];
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
