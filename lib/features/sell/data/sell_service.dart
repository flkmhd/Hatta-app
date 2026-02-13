import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/create_product_input.dart';

class SellService {
  SellService({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  static const String bucketName = 'product-images';

  Future<List<String>> uploadProductImages({
    required String userId,
    required List<XFile> images,
  }) async {
    final uploadedPaths = <String>[];
    final publicUrls = <String>[];
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    try {
      for (var index = 0; index < images.length; index++) {
        final image = images[index];
        final safeName = image.name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
        final path = 'users/$userId/products/${timestamp}_${index}_$safeName';
        final bytes = await image.readAsBytes();

        await _client.storage.from(bucketName).uploadBinary(
              path,
              bytes,
              fileOptions: FileOptions(
                upsert: false,
                contentType: _contentTypeForFileName(image.name),
              ),
            );

        uploadedPaths.add(path);
        publicUrls.add(_client.storage.from(bucketName).getPublicUrl(path));
      }

      return publicUrls;
    } catch (error, stackTrace) {
      debugPrint('uploadProductImages failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      await deleteUploadedImages(uploadedPaths);
      rethrow;
    }
  }

  Future<void> deleteUploadedImages(List<String> storagePaths) async {
    if (storagePaths.isEmpty) return;
    await _client.storage.from(bucketName).remove(storagePaths);
  }

  Future<void> createProduct({
    required String userId,
    required CreateProductInput input,
    required List<String> imageUrls,
  }) async {
    await _client.from('products').insert({
      'title': input.title.trim(),
      'description': input.description.trim(),
      'category': input.category.trim(),
      'condition': input.condition.trim(),
      'price': input.price,
      'image_urls': imageUrls,
      'seller_id': userId,
    });
  }

  static List<String> extractStoragePathsFromPublicUrls(List<String> publicUrls) {
    return publicUrls.map(_extractStoragePathFromPublicUrl).whereType<String>().toList();
  }

  static String? _extractStoragePathFromPublicUrl(String url) {
    final marker = '/storage/v1/object/public/$bucketName/';
    final index = url.indexOf(marker);
    if (index == -1) return null;
    return Uri.decodeComponent(url.substring(index + marker.length));
  }

  String _contentTypeForFileName(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.heic') || lower.endsWith('.heif')) return 'image/heic';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    return 'image/jpeg';
  }
}
