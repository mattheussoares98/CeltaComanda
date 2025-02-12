import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class LastImportModel extends Equatable {
  final DateTime? products;
  final DateTime? images;
  final DateTime? users;

  const LastImportModel({
    required this.products,
    required this.images,
    required this.users,
  });

  @override
  List<Object?> get props => [products, images];

  factory LastImportModel.fromJson(Map json) => LastImportModel(
        products:
            json['products'] == null ? null : DateTime.parse(json['products']),
        images: json['images'] == null ? null : DateTime.parse(json['images']),
        users: json['users'] == null ? null : DateTime.parse(json['users']),
      );

  factory LastImportModel.fromEntity(LastImportEntity entity) =>
      LastImportModel(
        products: entity.products,
        images: entity.images,
        users: entity.users,
      );

  Map<String, dynamic> toJson() => {
        'products': products?.toIso8601String(),
        'images': images?.toIso8601String(),
        'users': users?.toIso8601String(),
      };

  LastImportEntity toEntity() => LastImportEntity(
        products: products,
        images: images,
        users: users,
      );
}
