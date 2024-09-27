// ignore_for_file: non_constant_identifier_names
import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class ExpansibleGroupsViewModel extends Equatable {
  final String Name;
  final String ExpansibleGroupId;
  final String ExpansibleGroupType;
  final String OrderClassification;
  final List<String?> subgroups;

  @override
  List get props => [
        Name,
        ExpansibleGroupId,
        ExpansibleGroupType,
        OrderClassification,
        subgroups,
      ];

  const ExpansibleGroupsViewModel({
    required this.Name,
    required this.ExpansibleGroupId,
    required this.ExpansibleGroupType,
    required this.OrderClassification,
    required this.subgroups,
  });

  factory ExpansibleGroupsViewModel.fromEntity({
    required ExpansibleGroupEntity entity,
    required String groupName,
    required String? subgroupName,
  }) =>
      ExpansibleGroupsViewModel(
        Name: groupName,
        ExpansibleGroupId: entity.ExpansibleGroupId.toString(),
        ExpansibleGroupType: entity.ExpansibleGroupType.toString(),
        OrderClassification: entity.OrderClassification.toString(),
        subgroups: subgroupName == null ? [] : [subgroupName],
      );

  ExpansibleGroupEntity toEntity() => ExpansibleGroupEntity(
        Name: Name,
        ExpansibleGroupId: int.tryParse(ExpansibleGroupId) ?? 0,
        ExpansibleGroupType: int.tryParse(ExpansibleGroupType) ?? 0,
        OrderClassification: int.tryParse(OrderClassification) ?? 0,
      );
}
