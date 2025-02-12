import 'package:equatable/equatable.dart';

import 'group_permission_concentrator.dart';

class GroupPermissionConcentratorEntity extends Equatable {
  final int? GroupPermissionsId;
  final PermissionEntity? Permission;
  final int? GroupId;
  final bool? IsActive;

  const GroupPermissionConcentratorEntity({
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
}
