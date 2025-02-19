import '../../../data/models/models.dart';

abstract class LoadImages {
  Future<List<ImageModel>> load({
    required bool getLocalImages,
    required List<String> updatedImages,
  });
}
