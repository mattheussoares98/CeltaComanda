import 'dart:io';
import 'dart:typed_data';

class ImageModel {
  final String plu;
  final String? enterpriseName;
  final String imagePath;
  final Uint8List? image;
  final File? file;
  final bool isLogoImage;
  final bool isMarketingImage;
  final String uniqueId;

  ImageModel({
    required this.plu,
    required this.enterpriseName,
    required this.imagePath,
    required this.image,
    required this.file,
    required this.isLogoImage,
    required this.isMarketingImage,
    String? uniqueId,
  }) : uniqueId = uniqueId ?? DateTime.now().millisecondsSinceEpoch.toString();
}
