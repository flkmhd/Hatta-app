import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/models/create_product_input.dart';
import '../controllers/sell_controller.dart';

class _SelectedImage {
  const _SelectedImage({required this.file, required this.bytes});

  final XFile file;
  final Uint8List bytes;
}

/// Sell Page matching React's SellPage.tsx multi-step form
class SellPage extends ConsumerStatefulWidget {
  const SellPage({super.key});

  @override
  ConsumerState<SellPage> createState() => _SellPageState();
}

class _SellPageState extends ConsumerState<SellPage> {
  static const int _maxImages = 5;
  static const List<String> _conditions = ['Neuf', 'Tres bon', 'Bon'];

  int _currentStep = 0;
  String _selectedCondition = _conditions.first;
  final List<_SelectedImage> _selectedImages = [];

  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sizeController = TextEditingController();
  final _priceController = TextEditingController();

  final List<String> _stepKeys = [
    'sell.step1',
    'sell.step2',
    'sell.step3',
    'sell.step4',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _sizeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImages(AppLocalizations? l10n) async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(
      imageQuality: 85,
      maxHeight: 2400,
      maxWidth: 2400,
    );

    if (images.isEmpty) return;

    if (_selectedImages.length + images.length > _maxImages) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n?.translate('sell.upload') ?? 'You can upload up to 5 photos.',
          ),
        ),
      );
      return;
    }

    final loaded = <_SelectedImage>[];
    for (final image in images) {
      final bytes = await image.readAsBytes();
      loaded.add(_SelectedImage(file: image, bytes: bytes));
    }

    if (!mounted) return;
    setState(() {
      _selectedImages.addAll(loaded);
    });
  }

  Future<void> _publish() async {
    final price = double.tryParse(_priceController.text.trim());
    final input = CreateProductInput(
      title: _titleController.text,
      description: _descriptionController.text,
      category: _categoryController.text,
      size: _sizeController.text,
      condition: _selectedCondition,
      price: price,
      images: _selectedImages.map((image) => image.file).toList(),
    );

    try {
      await ref.read(sellControllerProvider.notifier).publish(input);
      if (!mounted) return;

      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product published successfully.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_humanizeError(error))),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _selectedCondition = _conditions.first;
      _selectedImages.clear();
      _titleController.clear();
      _categoryController.clear();
      _descriptionController.clear();
      _sizeController.clear();
      _priceController.clear();
    });
  }

  String _humanizeError(Object error) {
    if (error is ArgumentError) {
      return error.message?.toString() ?? 'Please complete all required fields.';
    }
    if (error is StateError) {
      return error.message;
    }
    if (error is StorageException) {
      final status = error.statusCode?.toString() ?? 'unknown';
      return 'Image upload failed (status: $status): ${error.message}';
    }
    if (error is PostgrestException) {
      return error.message;
    }
    return 'Failed to publish product. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final publishState = ref.watch(sellControllerProvider);
    final isPublishing = publishState.isLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n?.translate('sell.title') ?? 'Vends ton article'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: List.generate(4, (index) {
                  final isActive = index <= _currentStep;
                  final label = l10n?.translate(_stepKeys[index]) ?? 'Step ${index + 1}';

                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 4,
                          margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.primary : AppColors.muted,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            color: isActive ? AppColors.primary : AppColors.mutedForeground,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Expanded(child: _buildStepContent(context, l10n)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isPublishing
                            ? null
                            : () {
                                setState(() {
                                  _currentStep--;
                                });
                              },
                        child: const Text('Retour'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isPublishing
                          ? null
                          : () async {
                              if (_currentStep < 3) {
                                setState(() {
                                  _currentStep++;
                                });
                              } else {
                                await _publish();
                              }
                            },
                      child: isPublishing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _currentStep < 3
                                  ? l10n?.translate('sell.continue') ?? 'Continuer'
                                  : l10n?.translate('sell.publish') ?? 'Publier l\'article',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, AppLocalizations? l10n) {
    switch (_currentStep) {
      case 0:
        return _buildPhotosStep(context, l10n);
      case 1:
        return _buildDetailsStep(context, l10n);
      case 2:
        return _buildConditionStep(context, l10n);
      case 3:
        return _buildPriceStep(context, l10n);
      default:
        return const SizedBox();
    }
  }

  Widget _buildPhotosStep(BuildContext context, AppLocalizations? l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _pickImages(l10n),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.secondaryDark
                    : AppColors.secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 52,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n?.translate('sell.upload') ?? 'Add up to 5 photos',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: AppColors.mutedForeground),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n?.translate('sell.upload_hint') ?? 'Tap to add photos',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.mutedForeground),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedImages.isEmpty
                ? Center(
                    child: Text(
                      'No photos selected yet.',
                      style: TextStyle(color: AppColors.mutedForeground),
                    ),
                  )
                : GridView.builder(
                    itemCount: _selectedImages.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final selected = _selectedImages[index];
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              selected.bytes,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImages.removeAt(index);
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep(BuildContext context, AppLocalizations? l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: l10n?.translate('sell.item_title') ?? 'Titre de l\'article',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _categoryController,
            decoration: InputDecoration(
              labelText: l10n?.translate('sell.category') ?? 'Categorie',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: l10n?.translate('sell.description') ?? 'Description',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _sizeController,
            decoration: InputDecoration(
              labelText: l10n?.translate('sell.size') ?? 'Taille',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionStep(BuildContext context, AppLocalizations? l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n?.translate('search.condition') ?? 'Etat',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _buildConditionOption(
            context,
            l10n?.translate('condition.new') ?? 'Neuf',
            'Avec etiquette, jamais porte',
            _selectedCondition == 'Neuf',
            'Neuf',
          ),
          const SizedBox(height: 12),
          _buildConditionOption(
            context,
            l10n?.translate('condition.very_good') ?? 'Tres bon',
            'Quelques utilisations, aucun defaut',
            _selectedCondition == 'Tres bon',
            'Tres bon',
          ),
          const SizedBox(height: 12),
          _buildConditionOption(
            context,
            l10n?.translate('condition.good') ?? 'Bon',
            'Usure legere mais bien entretenu',
            _selectedCondition == 'Bon',
            'Bon',
          ),
        ],
      ),
    );
  }

  Widget _buildConditionOption(
    BuildContext context,
    String title,
    String subtitle,
    bool isSelected,
    String storedValue,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCondition = storedValue;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceStep(BuildContext context, AppLocalizations? l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              labelText: l10n?.translate('sell.price') ?? 'Prix en DZD',
              suffixText: 'DZD',
            ),
          ),
        ],
      ),
    );
  }
}
