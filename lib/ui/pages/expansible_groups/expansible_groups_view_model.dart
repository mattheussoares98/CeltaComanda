// ignore_for_file: non_constant_identifier_names

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

class ExpansibleGroupsViewModel extends Equatable {
  final String Name;
  final int ExpansibleGroupId;
  final int ExpansibleGroupType;
  final int OrderClassification;

  @override
  List get props =>
      [Name, ExpansibleGroupId, ExpansibleGroupType, OrderClassification];

  const ExpansibleGroupsViewModel({
    required this.Name,
    required this.ExpansibleGroupId,
    required this.ExpansibleGroupType,
    required this.OrderClassification,
  });

  factory ExpansibleGroupsViewModel.fromEntity(ExpansibleGroupEntity entity) =>
      ExpansibleGroupsViewModel(
        Name: entity.Name,
        ExpansibleGroupId: entity.ExpansibleGroupId,
        ExpansibleGroupType: entity.ExpansibleGroupType,
        OrderClassification: entity.OrderClassification,
      );
}
