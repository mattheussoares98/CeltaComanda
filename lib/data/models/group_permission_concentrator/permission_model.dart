import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class PermissionModel extends Equatable {
  final String? Name;
  final int? PermissionId;
  final int? PermissionsFatherId;
  final int? PermissionsAbsolutId;
  final int? OrderView;

  const PermissionModel({
    required this.Name,
    required this.PermissionId,
    required this.PermissionsFatherId,
    required this.PermissionsAbsolutId,
    required this.OrderView,
  });

  @override
  List<Object?> get props => [
        Name,
        PermissionId,
        PermissionsFatherId,
        PermissionsAbsolutId,
        OrderView,
      ];

  factory PermissionModel.fromJson(Map json) {
    return PermissionModel(
      Name: json['Name'],
      PermissionId: json['PermissionId'],
      PermissionsFatherId: json['PermissionsFatherId'],
      PermissionsAbsolutId: json['PermissionsAbsolutId'],
      OrderView: json['OrderView'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Name': Name,
      'PermissionId': PermissionId,
      'PermissionsFatherId': PermissionsFatherId,
      'PermissionsAbsolutId': PermissionsAbsolutId,
      'OrderView': OrderView,
    };
  }

  PermissionEntity toEntity() {
    return PermissionEntity(
      Name: Name,
      PermissionId: PermissionId,
      PermissionsFatherId: PermissionsFatherId,
      PermissionsAbsolutId: PermissionsAbsolutId,
      OrderView: OrderView,
    );
  }

  factory PermissionModel.fromEntity(PermissionEntity entity) =>
      PermissionModel(
        Name: entity.Name,
        PermissionId: entity.PermissionId,
        PermissionsFatherId: entity.PermissionsFatherId,
        PermissionsAbsolutId: entity.PermissionsAbsolutId,
        OrderView: entity.OrderView,
      );
}
