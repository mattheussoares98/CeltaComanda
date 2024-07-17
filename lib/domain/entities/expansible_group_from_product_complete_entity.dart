// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class ExpansibleGroupFromProductCompleteEntity extends Equatable {
  final int ExpansibleGroupId;
  final int ProductInternalCodeOnErp;
  final String GroupName;
  final String ProductName;

  const ExpansibleGroupFromProductCompleteEntity({
    required this.ExpansibleGroupId,
    required this.ProductInternalCodeOnErp,
    required this.GroupName,
    required this.ProductName,
  });

  @override
  List<Object?> get props =>
      [ExpansibleGroupId, ProductInternalCodeOnErp, GroupName, ProductName];
}
