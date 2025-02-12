import 'package:equatable/equatable.dart';

class PermissionEntity extends Equatable {
  final String? Name;
  final int? PermissionId;
  final int? PermissionsFatherId;
  final int? PermissionsAbsolutId;
  final int? OrderView;

  const PermissionEntity({
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
}
