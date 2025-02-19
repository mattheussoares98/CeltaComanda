import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import 'group_permission_concentrator.dart';

class GroupPermissionConcentratorModel extends Equatable {
  final int? GroupId;
  final int? GroupPermissionsId;
  final bool? IsActive;
  final PermissionModel? Permission;

  const GroupPermissionConcentratorModel({
    required this.GroupId,
    required this.GroupPermissionsId,
    required this.IsActive,
    required this.Permission,
  });

  @override
  List<Object?> get props => [
        GroupId,
        GroupPermissionsId,
        IsActive,
        Permission,
      ];

  factory GroupPermissionConcentratorModel.fromJson(Map json) =>
      GroupPermissionConcentratorModel(
        GroupId: json["GroupId"],
        GroupPermissionsId: json["GroupPermissionsId"],
        IsActive: json["IsActive"] == 1 || json["IsActive"] == true,
        Permission: json["Permission"] == null
            ? null
            : PermissionModel.fromJson(json["Permission"]),
      );

  factory GroupPermissionConcentratorModel.fromEntity(
          GroupPermissionConcentratorEntity entity) =>
      GroupPermissionConcentratorModel(
        GroupId: entity.GroupId,
        GroupPermissionsId: entity.GroupPermissionsId,
        IsActive: entity.IsActive,
        Permission: entity.Permission == null
            ? null
            : PermissionModel.fromEntity(entity.Permission!),
      );

  GroupPermissionConcentratorEntity toEntity() =>
      GroupPermissionConcentratorEntity(
        GroupId: GroupId,
        GroupPermissionsId: GroupPermissionsId,
        IsActive: IsActive,
        Permission: Permission?.toEntity(),
      );

  Map<String, dynamic> toJson() => {
        "GroupId": GroupId,
        "GroupPermissionsId": GroupPermissionsId,
        "IsActive": IsActive,
        "Permission": Permission?.toJson(),
      };
}
