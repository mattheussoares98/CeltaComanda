import 'dart:typed_data';

class ImageModel {
  final String pluOrEan;
  final Uint8List image;
  final bool keyIsEan;

  ImageModel({
    required this.pluOrEan,
    required this.image,
    required this.keyIsEan,
  });

  factory ImageModel.fromJson(Map json) {
    return ImageModel(
      pluOrEan: json['pluOrEan'],
      image: json['image'],
      keyIsEan: json['keyIsEan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pluOrEan': pluOrEan,
      'image': image,
      'keyIsEan': keyIsEan,
    };
  }
}
