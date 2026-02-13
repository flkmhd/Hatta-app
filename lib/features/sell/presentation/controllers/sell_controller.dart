import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/sell_service.dart';
import '../../domain/models/create_product_input.dart';

final sellServiceProvider = Provider<SellService>((ref) {
  return SellService();
});

class SellController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> publish(CreateProductInput input) async {
    final validationErrors = input.validationErrors;
    if (validationErrors.isNotEmpty) {
      throw ArgumentError(validationErrors.values.first);
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw StateError('You need to be logged in to publish a product.');
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(sellServiceProvider);
      final imageUrls = await service.uploadProductImages(
        userId: user.id,
        images: input.images,
      );

      try {
        await service.createProduct(
          userId: user.id,
          input: input,
          imageUrls: imageUrls,
        );
      } catch (_) {
        final uploadedPaths = SellService.extractStoragePathsFromPublicUrls(imageUrls);
        await service.deleteUploadedImages(uploadedPaths);
        rethrow;
      }
    });

    final currentError = state.error;
    if (currentError != null) {
      throw currentError;
    }
  }
}

final sellControllerProvider = AsyncNotifierProvider<SellController, void>(
  SellController.new,
);
