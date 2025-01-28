import 'dart:typed_data';

class ImageModel {
  final String pluOrEan;
  final Uint8List image;

  ImageModel({
    required this.pluOrEan,
    required this.image,
  });

  factory ImageModel.fromJson(Map json) {
    return ImageModel(
      pluOrEan: json['pluOrEan'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pluOrEan': pluOrEan,
      'image': image,
    };
  }
}
