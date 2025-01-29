import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class LastImportModel extends Equatable {
  final DateTime? products;
  final DateTime? images;

  const LastImportModel({
    required this.products,
    required this.images,
  });

  @override
  List<Object?> get props => [products, images];

  factory LastImportModel.fromJson(Map json) => LastImportModel(
        products:
            json['products'] == null ? null : DateTime.parse(json['products']),
        images: json['images'] == null ? null : DateTime.parse(json['images']),
      );

  factory LastImportModel.fromEntity(LastImportEntity entity) =>
      LastImportModel(
        products: entity.products,
        images: entity.images,
      );

  Map<String, dynamic> toJson() => {
        'products': products?.toIso8601String(),
        'images': images?.toIso8601String(),
      };

  LastImportEntity toEntity() => LastImportEntity(
        products: products,
        images: images,
      );
}
