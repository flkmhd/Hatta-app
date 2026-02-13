import 'package:image_picker/image_picker.dart';

class CreateProductInput {
  const CreateProductInput({
    required this.title,
    required this.description,
    required this.category,
    required this.size,
    required this.condition,
    required this.price,
    required this.images,
  });

  final String title;
  final String description;
  final String category;
  final String size;
  final String condition;
  final double? price;
  final List<XFile> images;

  Map<String, String> get validationErrors {
    final errors = <String, String>{};

    if (title.trim().isEmpty) {
      errors['title'] = 'Title is required.';
    }
    if (category.trim().isEmpty) {
      errors['category'] = 'Category is required.';
    }
    if (description.trim().isEmpty) {
      errors['description'] = 'Description is required.';
    }
    if (size.trim().isEmpty) {
      errors['size'] = 'Size is required.';
    }
    if (condition.trim().isEmpty) {
      errors['condition'] = 'Condition is required.';
    }
    if (price == null || price! <= 0) {
      errors['price'] = 'Price must be greater than 0.';
    }
    if (images.isEmpty) {
      errors['images'] = 'At least one image is required.';
    } else if (images.length > 5) {
      errors['images'] = 'You can upload up to 5 images.';
    }

    return errors;
  }

  bool get isValid => validationErrors.isEmpty;
}
