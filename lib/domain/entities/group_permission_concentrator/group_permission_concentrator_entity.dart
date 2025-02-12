import 'package:equatable/equatable.dart';

import 'group_permission_concentrator.dart';

class GroupPermissionConcentratorEntity extends Equatable {
  final int? GroupId;
  final String? GroupName;
  final bool? IsActive;
  final PermissionEntity? Permission;

  const GroupPermissionConcentratorEntity({
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
}
