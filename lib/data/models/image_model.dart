import 'dart:typed_data';

import '../../main/builders/builders.dart';

class ImageModel {
  final String pluOrEan;
  final String? enterpriseName;
  final String imagePath;
  final Uint8List? image;
  final bool keyIsEan;
  final bool isEnterpriseImage;

  ImageModel({
    required this.pluOrEan,
    required this.enterpriseName,
    required this.imagePath,
    required this.image,
    required this.keyIsEan,
    required this.isEnterpriseImage,
  });

  factory ImageModel.fromJson(Map json) {
    return ImageModel(
      pluOrEan: json['pluOrEan'],
      enterpriseName: json['enterpriseName'],
      imagePath: json['imagePath'],
      image: json['image'],
      keyIsEan: json['keyIsEan'],
      isEnterpriseImage: json['isEnterpriseImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pluOrEan': pluOrEan,
      'enterpriseName':
          enterpriseName ?? EnterpriseBuilder.entity!.enterpriseName,
      'imagePath': imagePath,
      'image': image,
      'keyIsEan': keyIsEan,
      'isEnterpriseImage': isEnterpriseImage,
    };
  }
}
