import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import '../../main/builders/builders.dart';

class LastImportModel extends Equatable {
  final DateTime? products;
  final DateTime? images;
  final DateTime? users;
  final DateTime? enterprise;
  final String? enterpriseName;

  const LastImportModel({
    required this.products,
    required this.images,
    required this.users,
    required this.enterprise,
    required this.enterpriseName,
  });

  @override
  List<Object?> get props => [products, images];

  factory LastImportModel.fromJson(Map json) => LastImportModel(
        products:
            json['products'] == null ? null : DateTime.parse(json['products']),
        images: json['images'] == null ? null : DateTime.parse(json['images']),
        users: json['users'] == null ? null : DateTime.parse(json['users']),
        enterprise: json['enterprise'] == null
            ? null
            : DateTime.parse(json['enterprise']),
        enterpriseName:
            json['enterpriseName'] ?? EnterpriseBuilder.entity?.enterpriseName,
      );

  factory LastImportModel.fromEntity(LastImportEntity entity) =>
      LastImportModel(
        products: entity.products,
        images: entity.images,
        users: entity.users,
        enterprise: entity.enterprise,
        enterpriseName: entity.enterpriseName,
      );

  Map<String, dynamic> toJson() => {
        'products': products?.toIso8601String(),
        'images': images?.toIso8601String(),
        'users': users?.toIso8601String(),
        'enterprise': enterprise?.toIso8601String(),
        'enterpriseName':
            enterpriseName ?? EnterpriseBuilder.entity?.enterpriseName,
      };

  LastImportEntity toEntity() => LastImportEntity(
        products: products,
        images: images,
        users: users,
        enterprise: enterprise,
        enterpriseName: enterpriseName,
      );
}
