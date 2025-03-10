

import 'package:equatable/equatable.dart';

class ExpansibleGroupFromProductsCompleteEntity extends Equatable {
  final int ExpansibleGroupId;
  final int ProductInternalCodeOnErp;
  final String GroupName;
  final String ProductName;

  const ExpansibleGroupFromProductsCompleteEntity({
    required this.ExpansibleGroupId,
    required this.ProductInternalCodeOnErp,
    required this.GroupName,
    required this.ProductName,
  });

  @override
  List<Object?> get props => [
        ExpansibleGroupId,
        ProductInternalCodeOnErp,
        GroupName,
        ProductName,
      ];
}
