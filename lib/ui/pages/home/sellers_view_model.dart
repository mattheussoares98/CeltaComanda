// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class SellersViewModel extends Equatable {
  final int SellersId;
  final int EnterpriseId;
  final String Name;
  final String PersonalizedCode;
  const SellersViewModel({
    required this.SellersId,
    required this.EnterpriseId,
    required this.Name,
    required this.PersonalizedCode,
  });

  SellerEntity toEntity() => SellerEntity(
        SellersId: SellersId,
        EnterpriseId: EnterpriseId,
        Name: Name,
        PersonalizedCode: PersonalizedCode,
      );

  factory SellersViewModel.fromEntity(SellerEntity entity) => SellersViewModel(
        SellersId: entity.SellersId,
        EnterpriseId: entity.EnterpriseId,
        Name: entity.Name,
        PersonalizedCode: entity.PersonalizedCode,
      );

  @override
  List<Object?> get props => [
        SellersId,
        EnterpriseId,
        Name,
        PersonalizedCode,
      ];
}
