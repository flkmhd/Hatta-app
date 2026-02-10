import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../home/domain/models/product.dart';

/// Category data class
class _Category {
  final String id;
  final String labelKey;
  final IconData icon;

  const _Category({
    required this.id,
    required this.labelKey,
    required this.icon,
  });
}

/// Search Page matching React's SearchPage.tsx
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';
  bool _showFilters = false;
  final Set<String> _selectedSizes = {};
  final Set<String> _selectedConditions = {};
  bool _isLoading = true;
  List<Product> _products = [];

  static const List<_Category> _categories = [
    _Category(id: 'all', labelKey: 'search.all', icon: Icons.auto_awesome),
    _Category(
      id: 'vetements',
      labelKey: 'search.clothes',
      icon: Icons.checkroom,
    ),
    _Category(
      id: 'chaussures',
      labelKey: 'search.shoes',
      icon: Icons.snowshoeing,
    ),
    _Category(
      id: 'accessoires',
      labelKey: 'search.accessories',
      icon: Icons.watch,
    ),
    _Category(
      id: 'traditionnel',
      labelKey: 'search.traditional',
      icon: Icons.diamond,
    ),
  ];

  static const List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Same mock data as HomeFeed for now
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

  List<Product> get _filteredProducts {
    return _products.where((product) {
      final matchesSearch = product.title.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      final matchesCategory =
          _selectedCategory == 'all' ||
          product.category.toLowerCase() == _selectedCategory;
      final matchesSize =
          _selectedSizes.isEmpty || _selectedSizes.contains(product.size);
      final matchesCondition =
          _selectedConditions.isEmpty ||
          _selectedConditions.contains(_conditionToString(product.condition));
      return matchesSearch &&
          matchesCategory &&
          matchesSize &&
          matchesCondition;
    }).toList();
  }

  String _conditionToString(ProductCondition condition) {
    switch (condition) {
      case ProductCondition.neuf:
        return 'Neuf';
      case ProductCondition.tresBon:
        return 'Très bon';
      case ProductCondition.bon:
        return 'Bon';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Header (sticky)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search Input Row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() {}),
                          decoration: InputDecoration(
                            hintText:
                                l10n?.translate('search.placeholder') ??
                                'Chercher un article...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.mutedForeground,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: AppColors.mutedForeground,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Filters Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showFilters = !_showFilters;
                          });
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _showFilters
                                ? AppColors.primary
                                : AppColors.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.tune,
                            color: _showFilters
                                ? Colors.white
                                : AppColors.foreground,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Category Chips
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isActive = _selectedCategory == category.id;

                        String label;
                        switch (category.id) {
                          case 'all':
                            label = l10n?.translate('search.all') ?? 'Tout';
                            break;
                          case 'vetements':
                            label =
                                l10n?.translate('search.clothes') ??
                                'Vêtements';
                            break;
                          case 'chaussures':
                            label =
                                l10n?.translate('search.shoes') ?? 'Chaussures';
                            break;
                          case 'accessoires':
                            label =
                                l10n?.translate('search.accessories') ??
                                'Accessoires';
                            break;
                          case 'traditionnel':
                            label =
                                l10n?.translate('search.traditional') ??
                                'Traditionnel';
                            break;
                          default:
                            label = category.id;
                        }

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category.id;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.primary
                                  : AppColors.secondary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  category.icon,
                                  size: 16,
                                  color: isActive
                                      ? Colors.white
                                      : AppColors.foreground,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isActive
                                        ? Colors.white
                                        : AppColors.foreground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Filters Panel
                  if (_showFilters) ...[
                    const SizedBox(height: 16),
                    // Sizes
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.translate('search.size') ?? 'Taille',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _sizes.map((size) {
                            final isSelected = _selectedSizes.contains(size);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedSizes.remove(size);
                                  } else {
                                    _selectedSizes.add(size);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.secondary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.foreground,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Conditions
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.translate('search.condition') ?? 'État',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildConditionChip(
                              'Neuf',
                              l10n?.translate('condition.new') ?? 'Neuf',
                            ),
                            _buildConditionChip(
                              'Très bon',
                              l10n?.translate('condition.very_good') ??
                                  'Très bon',
                            ),
                            _buildConditionChip(
                              'Bon',
                              l10n?.translate('condition.good') ?? 'Bon',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Results
            Expanded(child: _buildResults(l10n)),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionChip(String key, String label) {
    final isSelected = _selectedConditions.contains(key);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedConditions.remove(key);
          } else {
            _selectedConditions.add(key);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.foreground,
          ),
        ),
      ),
    );
  }

  Widget _buildResults(AppLocalizations? l10n) {
    final filtered = _filteredProducts;

    return CustomScrollView(
      slivers: [
        // Results count
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              '${filtered.length} ${l10n?.translate(filtered.length == 1 ? 'search.results' : 'search.results_plural') ?? 'résultats'}',
              style: TextStyle(fontSize: 14, color: AppColors.mutedForeground),
            ),
          ),
        ),

        // Product Grid or Loading/Empty State
        if (_isLoading)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
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
            ),
          )
        else if (filtered.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 64,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n?.translate('search.no_results') ??
                        'Aucun article trouvé',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n?.translate('search.try_filters') ??
                        'Essaie d\'autres filtres',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _getColumnCount(context),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.58,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = filtered[index];
                return ProductCard(product: product);
              }, childCount: filtered.length),
            ),
          ),

        // Bottom Padding
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  int _getColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1280) return 6;
    if (width >= 1024) return 5;
    if (width >= 768) return 4;
    if (width >= 640) return 3;
    return 2;
  }
}
