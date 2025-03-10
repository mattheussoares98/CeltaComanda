

import 'package:equatable/equatable.dart';

class SellerEntity extends Equatable {
  final int SellersId;
  final int EnterpriseId;
  final String Name;
  final String PersonalizedCode;

  const SellerEntity({
    required this.SellersId,
    required this.EnterpriseId,
    required this.Name,
    required this.PersonalizedCode,
  });

  @override
  List get props => [
        SellersId,
        EnterpriseId,
        Name,
        PersonalizedCode,
      ];
}
