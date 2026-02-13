import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/product.dart';

class ProductsService {
  ProductsService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Product>> fetchLatestProducts({int limit = 50}) async {
    final response = await _client
        .from('products')
        .select(
          'id, title, description, price, condition, category, image_urls, is_sold, seller:profiles!products_seller_id_fkey(username, avatar_url, wilaya_id)',
        )
        .eq('is_sold', false)
        .order('created_at', ascending: false)
        .limit(limit);

    final rows = (response as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    return rows.map((row) {
      return Product.fromSupabase(row);
    }).toList();
  }
}
