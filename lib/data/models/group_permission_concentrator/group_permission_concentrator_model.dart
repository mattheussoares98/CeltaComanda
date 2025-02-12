import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import 'group_permission_concentrator.dart';

class GroupPermissionConcentratorModel extends Equatable {
  final int? GroupId;
  final String? GroupName;
  final bool? IsActive;
  final PermissionModel? Permission;

  const GroupPermissionConcentratorModel({
    required this.GroupId,
    required this.GroupName,
    required this.IsActive,
    required this.Permission,
  });

  @override
  List<Object?> get props => [
        GroupId,
        GroupName,
        IsActive,
        Permission,
      ];

  factory GroupPermissionConcentratorModel.fromJson(Map json) =>
      GroupPermissionConcentratorModel(
        GroupId: json["GroupId"],
        GroupName: json["GroupName"],
        IsActive: json["IsActive"] == 1,
        Permission: json["Permission"] == null
            ? null
            : PermissionModel.fromJson(json["Permission"]),
      );

  factory GroupPermissionConcentratorModel.fromEntity(
          GroupPermissionConcentratorEntity entity) =>
      GroupPermissionConcentratorModel(
        GroupId: entity.GroupId,
        GroupName: entity.GroupName,
        IsActive: entity.IsActive,
        Permission: entity.Permission == null
            ? null
            : PermissionModel.fromEntity(entity.Permission!),
      );

  GroupPermissionConcentratorEntity toEntity() =>
      GroupPermissionConcentratorEntity(
        GroupId: GroupId,
        GroupName: GroupName,
        IsActive: IsActive,
        Permission: Permission?.toEntity(),
      );

  Map<String, dynamic> toJson() => {
        "GroupId": GroupId,
        "GroupName": GroupName,
        "IsActive": IsActive,
        "Permission": Permission?.toJson(),
      };
}
