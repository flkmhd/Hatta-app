import 'package:equatable/equatable.dart';

/// Product condition enum
enum ProductCondition {
  neuf, // "Neuf" - New
  tresBon, // "Très bon" - Very Good
  bon, // "Bon" - Good
}

extension ProductConditionExtension on ProductCondition {
  String get displayName {
    switch (this) {
      case ProductCondition.neuf:
        return 'Neuf';
      case ProductCondition.tresBon:
        return 'Très bon';
      case ProductCondition.bon:
        return 'Bon';
    }
  }

  static ProductCondition fromString(String value) {
    switch (value.toLowerCase()) {
      case 'neuf':
        return ProductCondition.neuf;
      case 'très bon':
      case 'tres bon':
        return ProductCondition.tresBon;
      case 'bon':
        return ProductCondition.bon;
      default:
        return ProductCondition.bon;
    }
  }
}

/// Seller model
class Seller extends Equatable {
  final String name;
  final String avatar;
  final double rating;
  final int reviewCount;

  const Seller({
    required this.name,
    required this.avatar,
    required this.rating,
    required this.reviewCount,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      name: json['username'] ?? 'Unknown',
      avatar:
          json['avatar_url'] ??
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      rating: 5.0,
      reviewCount: 0,
    );
  }

  @override
  List<Object?> get props => [name, avatar, rating, reviewCount];
}

/// Product model matching React's Product interface
class Product extends Equatable {
  final String id;
  final String image;
  final String title;
  final String description;
  final double price;
  final String size;
  final ProductCondition condition;
  final String category;
  final String location;
  final String wilaya;
  final bool isLocalPickup;
  final bool sellerVerified;
  final Seller seller;
  final List<String> images;

  const Product({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.size,
    required this.condition,
    required this.category,
    required this.location,
    required this.wilaya,
    required this.isLocalPickup,
    required this.sellerVerified,
    required this.seller,
    required this.images,
  });

  /// Factory to create Product from Supabase response
  factory Product.fromSupabase(Map<String, dynamic> json) {
    final imageUrls = (json['image_urls'] as List<dynamic>?) ?? [];
    final sellerData = json['seller'] as Map<String, dynamic>?;
    final fallbackWilaya = _getWilayaName(sellerData?['wilaya_id'] as int?);

    return Product(
      id: json['id'].toString(),
      image: imageUrls.isNotEmpty
          ? imageUrls[0] as String
          : 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=400&q=80',
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      size: json['size'] as String? ?? 'Unique',
      condition: ProductConditionExtension.fromString(
        json['condition'] as String? ?? 'Bon',
      ),
      category: json['category'] as String? ?? '',
      location: json['wilaya'] as String? ?? fallbackWilaya,
      wilaya: json['wilaya'] as String? ?? fallbackWilaya,
      isLocalPickup: json['is_local_pickup'] as bool? ?? true,
      sellerVerified: json['seller_verified'] as bool? ?? true,
      seller: sellerData != null
          ? Seller.fromJson(sellerData)
          : const Seller(
              name: 'Unknown',
              avatar:
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
              rating: 5.0,
              reviewCount: 0,
            ),
      images: imageUrls.map((e) => e.toString()).toList(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    image,
    title,
    description,
    price,
    size,
    condition,
    category,
    location,
    wilaya,
    isLocalPickup,
    sellerVerified,
    seller,
    images,
  ];
}

/// Helper function to map wilaya_id to name
String _getWilayaName(int? id) {
  if (id == null) return 'Algérie';

  const wilayas = {
    16: 'Alger',
    31: 'Oran',
    25: 'Constantine',
    23: 'Annaba',
    9: 'Blida',
    13: 'Tlemcen',
    19: 'Sétif',
    6: 'Béjaïa',
  };

  return wilayas[id] ?? 'Algérie';
}
