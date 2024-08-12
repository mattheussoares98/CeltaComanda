// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class ExpansibleGroupFromProductViewModel extends Equatable {
  bool selected = false;
  final String ProductName;
  final String GroupName;
  final String ExpansibleGroupId;
  final String ProductInternalCodeOnErp;

  ExpansibleGroupFromProductViewModel({
    required this.selected,
    required this.ProductName,
    required this.GroupName,
    required this.ExpansibleGroupId,
    required this.ProductInternalCodeOnErp,
  });

  factory ExpansibleGroupFromProductViewModel.fromExpansibleGroupsFromProductsCompleteEntity(
          CommentsEntity entity) =>
      ExpansibleGroupFromProductViewModel(
        selected: false,
        ProductName: entity.ProductName,
        GroupName: entity.GroupName,
        ExpansibleGroupId: entity.ExpansibleGroupId.toString(),
        ProductInternalCodeOnErp: entity.ProductInternalCodeOnErp.toString(),
      );

  @override
  List<Object?> get props => [
        selected,
        ProductName,
        GroupName,
        ExpansibleGroupId,
        ProductInternalCodeOnErp,
      ];
}
